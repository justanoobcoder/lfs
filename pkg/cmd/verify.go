package cmd

import (
	"bufio"
	"crypto/md5"
	"fmt"
	"io"
	"os"
	"strings"

	"github.com/justanoobcoder/lfs/internal"
	"github.com/spf13/cobra"
)

func verifyRun(cmd *cobra.Command, args []string) {
	config := internal.LoadConfig()
	f, err := os.Open(config.Md5sumsFile)
	if err != nil {
		fmt.Println(internal.Notify(internal.LevelError, fmt.Sprintf("failed to open %s\n%v", config.Md5sumsFile, err)))
	}
	defer f.Close()

	var failed []string
	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := scanner.Text()
		parts := strings.Fields(line)
		if len(parts) != 2 {
			continue
		}
		expectedHash, fileName := parts[0], parts[1]

		f, err := os.Open(fileName)
		if err != nil {
			fmt.Println(internal.Notify(internal.LevelError, fmt.Sprintf("failed to open %s\n%v", fileName, err)))
			failed = append(failed, fileName)
			continue
		}

		h := md5.New()
		if _, err := io.Copy(h, f); err != nil {
			f.Close()
			fmt.Println(internal.Notify(internal.LevelError, fmt.Sprintf("failed to read %s\n%v", fileName, err)))
			failed = append(failed, fileName)
			continue
		}
		f.Close()

		actualHash := fmt.Sprintf("%x", h.Sum(nil))
		if actualHash != expectedHash {
			fmt.Println(internal.Notify(internal.LevelError, fmt.Sprintf("FAILED %s", fileName)))
			failed = append(failed, fileName)
		} else {
			fmt.Println(internal.Notify(internal.LevelSuccess, fmt.Sprintf("OK %s", fileName)))
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Println(internal.Notify(internal.LevelError, fmt.Sprintf("failed to read %s\n%v", config.Md5sumsFile, err)))
	}

	fmt.Println("---------------------------------------------------")

	if len(failed) > 0 {
		fmt.Println(internal.Notify(internal.LevelInfo, fmt.Sprintf("%d files failed", len(failed))))
		if err := internal.LogToFile(config.FailedVerifyLogFile, failed); err != nil {
			fmt.Println(internal.Notify(internal.LevelError, err.Error()))
		}
		fmt.Println(internal.Notify(internal.LevelInfo, fmt.Sprintf("failed packages logged to %s", config.FailedVerifyLogFile)))
	}
}

var verifyCmd = &cobra.Command{
	Use:   "verify",
	Short: "Verify packages and patches using md5 hashes",
	Run:   verifyRun,
}

func init() {
	rootCmd.AddCommand(verifyCmd)
}
