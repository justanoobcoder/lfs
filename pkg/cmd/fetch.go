package cmd

import (
	"fmt"

	"github.com/justanoobcoder/lfs/internal"
	"github.com/spf13/cobra"
)

var (
	wget bool
	md5sums  bool
)

func fetchRun(cmd *cobra.Command, args []string) {
	if !wget && !md5sums {
		cmd.Help()
		return
	}

	config := internal.LoadConfig()

	var status internal.Status
	var total, errCount, skipCount int
	if wget {
		total++
		if err := internal.DownloadFile(config.WgetListLink, config.WgetListFile, force, &status); err != nil {
			errCount++
			fmt.Println(internal.Notify(internal.LevelError, err.Error()))
		}
	}
	if status == internal.StatusSkipped {
		skipCount++
	}
	if md5sums {
		total++
		if err := internal.DownloadFile(config.Md5sumsLink, config.Md5sumsFile, force, &status); err != nil {
			errCount++
			fmt.Println(internal.Notify(internal.LevelError, err.Error()))
		}
	}
	if status == internal.StatusSkipped {
		skipCount++
	}

	fmt.Println("---------------------------------------------------")
	fmt.Println(internal.Notify(internal.LevelInfo, fmt.Sprintf("done: %d total, %d succeeded, %d skipped, %d failed",
		total, total-errCount-skipCount, skipCount, errCount)))
}

var fetchCmd = &cobra.Command{
	Use:   "fetch",
	Short: "Download wget-list and md5sums",
	Run:   fetchRun,
}

func init() {
	rootCmd.AddCommand(fetchCmd)
	fetchCmd.Flags().BoolVarP(&wget, "wget-list", "w", false, "Download wget-list file")
	fetchCmd.Flags().BoolVarP(&md5sums, "md5sums", "m", false, "Download md5sums file")
	fetchCmd.Flags().BoolVarP(&force, "force", "f", false, "Override existing files")
}
