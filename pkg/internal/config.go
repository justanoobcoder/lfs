package internal

import (
	"fmt"
	"os"

	"github.com/spf13/viper"
)

type Config struct {
	WgetListLink          string
	WgetListFile          string
	Md5sumsLink           string
	Md5sumsFile           string
	FailedPackagesLogFile string
	FailedVerifyLogFile   string
}

func LoadConfig() Config {
	viper.SetConfigName("config")
	viper.SetConfigType("json")
	viper.AddConfigPath(".")

	if err := viper.ReadInConfig(); err != nil {
		fmt.Println(Notify(LevelError, "Can not read config.json"))
		os.Exit(1)
	}

	return Config{
		WgetListLink:          viper.GetString("wget-list-link"),
		WgetListFile:          viper.GetString("wget-list-file"),
		Md5sumsLink:           viper.GetString("md5sums-link"),
		Md5sumsFile:           viper.GetString("md5sums-file"),
		FailedPackagesLogFile: viper.GetString("failed-packages-log"),
		FailedVerifyLogFile:   viper.GetString("failed-verify-log"),
	}
}
