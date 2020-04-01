package db

type Review struct {
	Author  string
	Score   int
	Planet  string
	Content string
	Private bool
}

func ValidateReview(r Review) bool {
	validScore := r.Score >= 1 && r.Score <= 5
	return ValidatePlanet(r.Planet) && validScore
}
