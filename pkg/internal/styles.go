package internal

import (
	"time"

	"charm.land/lipgloss/v2"
)

var (
	colorRed    = lipgloss.Color("#FF4D4F")
	colorOrange = lipgloss.Color("#FA8C16")
	colorGreen  = lipgloss.Color("#52C41A")
	colorBlue   = lipgloss.Color("#1890FF")
	colorYellow = lipgloss.Color("#FADB14")
	colorPurple = lipgloss.Color("#722ED1")
	colorGray   = lipgloss.Color("#8C8C8C")
	colorWhite  = lipgloss.Color("#FFFFFF")
	colorDark   = lipgloss.Color("#141414")

	bgRed    = lipgloss.Color("#2D0B0B")
	bgOrange = lipgloss.Color("#2B1600")
	bgGreen  = lipgloss.Color("#0D2B00")
	bgBlue   = lipgloss.Color("#001529")
	bgYellow = lipgloss.Color("#2B2000")
	bgPurple = lipgloss.Color("#1A0A2E")
	bgGray   = lipgloss.Color("#1F1F1F")
)

var base = lipgloss.NewStyle().
	Padding(0, 1).
	Bold(true)

var BadgeError = base.
	Foreground(colorWhite).
	Background(colorRed)

var BadgeWarning = base.
	Foreground(colorDark).
	Background(colorOrange)

var BadgeInfo = base.
	Foreground(colorWhite).
	Background(colorBlue)

var BadgeSuccess = base.
	Foreground(colorWhite).
	Background(colorGreen)

var BadgeFailure = base.
	Foreground(colorWhite).
	Background(colorPurple)

var BadgeDebug = base.
	Foreground(colorWhite).
	Background(colorGray)

var BadgePending = base.
	Foreground(colorDark).
	Background(colorYellow)

var box = lipgloss.NewStyle().
	Border(lipgloss.RoundedBorder()).
	Padding(0, 2).
	Width(60)

var BoxError = box.
	BorderForeground(colorRed).
	Foreground(colorRed).
	Background(bgRed)

var BoxWarning = box.
	BorderForeground(colorOrange).
	Foreground(colorOrange).
	Background(bgOrange)

var BoxInfo = box.
	BorderForeground(colorBlue).
	Foreground(colorBlue).
	Background(bgBlue)

var BoxSuccess = box.
	BorderForeground(colorGreen).
	Foreground(colorGreen).
	Background(bgGreen)

var BoxFailure = box.
	BorderForeground(colorPurple).
	Foreground(colorPurple).
	Background(bgPurple)

var BoxDebug = box.
	BorderForeground(colorGray).
	Foreground(colorGray).
	Background(bgGray)

var BoxPending = box.
	BorderForeground(colorYellow).
	Foreground(colorYellow).
	Background(bgYellow)

type Level int

const (
	LevelError Level = iota
	LevelWarning
	LevelInfo
	LevelSuccess
	LevelFailure
	LevelDebug
	LevelPending
)

type notifyConfig struct {
	icon  string
	label string
	badge lipgloss.Style
	box   lipgloss.Style
}

var notifyMap = map[Level]notifyConfig{
	LevelError:   {"✖", "ERROR", BadgeError, BoxError},
	LevelWarning: {"⚠", "WARNING", BadgeWarning, BoxWarning},
	LevelInfo:    {"ⓘ", "INFO", BadgeInfo, BoxInfo},
	LevelSuccess: {"✔", "SUCCESS", BadgeSuccess, BoxSuccess},
	LevelFailure: {"✖", "FAILED", BadgeFailure, BoxFailure},
	LevelDebug:   {"⬡", "DEBUG", BadgeDebug, BoxDebug},
	LevelPending: {"◌", "PENDING", BadgePending, BoxPending},
}

func Notify(level Level, message string) string {
	cfg := notifyMap[level]
	timestamp := time.Now().Format("[15:04:05]")
	badge := cfg.badge.Render(cfg.icon + " " + cfg.label)
	return timestamp + " " + badge + "  " + message
}

func NotifyBox(level Level, title, body string) string {
	cfg := notifyMap[level]
	label := cfg.icon + " " + cfg.label + ": " + title
	content := lipgloss.NewStyle().Bold(true).Render(label) + "\n" + body
	return cfg.box.Render(content)
}
