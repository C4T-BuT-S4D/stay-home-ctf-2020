package db

import "testing"

func TestSomeShit(t *testing.T) {
	Init("localhost:6379")
	for _, u := range []string{"user1", "user2"} {
		err := AddUser(u, u)
		if err != nil {
			t.Error(err)
		}
	}

	err := AddReview(Review{
		Author:  "user1",
		Score:   3,
		Planet:  "Test",
		Content: "Test",
		Private: true,
	})

	if err != nil {
		t.Error(err)
	}

	err = AddReview(Review{
		Author:  "user1",
		Score:   3,
		Planet:  "Test",
		Content: "Test2",
		Private: false,
	})

	if err != nil {
		t.Error(err)
	}

	reviews := PlanetReviews("Test")
	if len(reviews) != 1 {
		t.Errorf("Failed to get planet review: %d", len(reviews))
	}

	reviews = SubscribeReviews("user2")

	if len(reviews) != 0 {
		t.Errorf("Failed to get planet review: %d", len(reviews))
	}

	if err := AddFollower("user1", "user2"); err != nil {
		t.Error(err)
	}

	reviews = SubscribeReviews("user2")

	if len(reviews) != 2 {
		t.Errorf("Failed to get planet review: %d", len(reviews))
	}

}

func TestListPlanetScores(t *testing.T) {
	Init("localhost:6379")
	scores := ListPlanetScores()
	if len(scores) < 1 {
		t.Fatal("Failed to get planet's scores")
	}
}
