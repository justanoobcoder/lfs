package cmd

import (
	"os"

	"github.com/spf13/cobra"
)

var (
	force bool
)

func rootRun(cmd *cobra.Command, args []string) {
	cmd.Help()
}

var rootCmd = &cobra.Command{
	Use:   "lfs",
	Short: "A CLI tool to download packages and patches from Linux From Scratch",
	Run:   rootRun,
}

func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}
