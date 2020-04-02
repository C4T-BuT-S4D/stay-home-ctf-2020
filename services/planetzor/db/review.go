package db

import "regexp"

type Review struct {
	Author  string
	Score   int
	Planet  string
	Content string
	Private bool
}

var scoreValidator = regexp.MustCompile(`[1-5]`)

func ValidateScore(score string) bool {
	return scoreValidator.Match([]byte(score))
}
