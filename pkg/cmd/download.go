package cmd

import (
	"bufio"
	"fmt"
	"os"

	"github.com/justanoobcoder/lfs/internal"
	"github.com/spf13/cobra"
)

var (
	jobNum int
)

func getPackageLinks(wgetListFile string) []string {
	links := []string{}

	file, err := os.Open(wgetListFile)
	if err != nil {
		if os.IsNotExist(err) {
			fmt.Println(internal.Notify(internal.LevelError, fmt.Sprintf("file %s does not exist, run `lfs fetch -w` first", wgetListFile)))
			os.Exit(1)
		}
		fmt.Println(internal.Notify(internal.LevelError, fmt.Sprintf("failed to open %s\n%v", wgetListFile, err)))
		os.Exit(1)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		links = append(links, scanner.Text())
	}

	return links
}

func downloadRun(cmd *cobra.Command, args []string) {
	config := internal.LoadConfig()
	links := getPackageLinks(config.WgetListFile)

	n := min(jobNum, len(links))
	internal.DownloadFiles(links, force, n, config.FailedPackagesLogFile)
}

var downloadCmd = &cobra.Command{
	Use:   "download",
	Short: "Download packages and patches from Linux From Scratch",
	Run:   downloadRun,
}

func init() {
	rootCmd.AddCommand(downloadCmd)
	downloadCmd.Flags().BoolVarP(&force, "force", "f", false, "Overwrite existing files")
	downloadCmd.Flags().IntVarP(&jobNum, "jobs", "j", 5, "Number of parallel downloads")
}
