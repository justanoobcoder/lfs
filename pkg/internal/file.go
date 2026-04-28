package internal

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"path"
	"sync"
	"time"
)

type Status int

const (
	StatusSucceeded Status = iota
	StatusFailed
	StatusSkipped
)

func DownloadFile(link string, filename string, override bool, status *Status) error {
	if !override {
		if _, err := os.Stat(filename); err == nil {
			*status = StatusSkipped
			fmt.Printf("%s already exists, skip downloading (use --force to override)\n", filename)
			return nil
		}
	}

	fmt.Println(Notify(LevelPending, fmt.Sprintf("start downloading %s...", filename)))
	start := time.Now()
	resp, err := http.Get(link)
	if err != nil {
		*status = StatusFailed
		return fmt.Errorf("failed to download from %s\n%v", link, err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		*status = StatusFailed
		return fmt.Errorf("failed to download from %s: HTTP status %d", link, resp.StatusCode)
	}

	out, err := os.Create(filename)
	if err != nil {
		*status = StatusFailed
		return fmt.Errorf("failed to create %s\n%v", filename, err)
	}
	defer out.Close()

	written, err := io.Copy(out, resp.Body)
	if err != nil {
		out.Close()
		os.Remove(filename)
		*status = StatusFailed
		return fmt.Errorf("failed to write to %s\n%v", filename, err)
	}

	elapsed := time.Since(start).Seconds()
	size := formatSize(written)
	fmt.Println(Notify(LevelSuccess, fmt.Sprintf("%s downloaded (%s, %.2fs)", filename, size, elapsed)))
	*status = StatusSucceeded

	return nil
}

type result struct {
	link   string
	err    error
	status Status
}

func LogToFile(logFile string, lines []string) error {
	if len(lines) == 0 {
		return nil
	}

	f, err := os.OpenFile(logFile, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
	if err != nil {
		return fmt.Errorf("failed to open log file %s: %v", logFile, err)
	}
	defer f.Close()

	for _, line := range lines {
		fmt.Fprintln(f, line)
	}
	fmt.Fprintln(f)

	return nil
}

func DownloadFiles(links []string, override bool, jobNum int, logFile string) {
	fmt.Println(Notify(LevelPending, fmt.Sprintf("start downloading %d packages...", len(links))))
	jobs := make(chan string, len(links))
	results := make(chan result, len(links))
	var wg sync.WaitGroup
	for range jobNum {
		wg.Go(func() {
			for link := range jobs {
				file := path.Base(link)
				var status Status
				err := DownloadFile(link, file, override, &status)
				results <- result{link, err, status}
			}
		})
	}
	for _, link := range links {
		jobs <- link
	}
	close(jobs)
	go func() {
		wg.Wait()
		close(results)
	}()

	var errCount, skipCount int
	var failedLinks []string

	for r := range results {
		if r.err != nil {
			errCount++
			fmt.Println(Notify(LevelError, r.err.Error()))
			failedLinks = append(failedLinks, r.link)
		} else if r.status == StatusSkipped {
			skipCount++
		}
	}

	fmt.Println("---------------------------------------------------")

	succeeded := len(links) - errCount - skipCount
	fmt.Println(Notify(LevelInfo, fmt.Sprintf(
		"done: %d total, %d succeeded, %d skipped, %d failed",
		len(links), succeeded, skipCount, errCount,
	)))

	if logFile != "" {
		if err := LogToFile(logFile, failedLinks); err != nil {
			fmt.Println(Notify(LevelError, err.Error()))
		} else if len(failedLinks) > 0 {
			fmt.Println(Notify(LevelInfo, fmt.Sprintf("failed packages logged to %s", logFile)))
		}
	}
}

func formatSize(bytes int64) string {
	switch {
	case bytes >= 1<<30:
		return fmt.Sprintf("%.2f GB", float64(bytes)/float64(1<<30))
	case bytes >= 1<<20:
		return fmt.Sprintf("%.2f MB", float64(bytes)/float64(1<<20))
	case bytes >= 1<<10:
		return fmt.Sprintf("%.2f KB", float64(bytes)/float64(1<<10))
	default:
		return fmt.Sprintf("%d B", bytes)
	}
}
