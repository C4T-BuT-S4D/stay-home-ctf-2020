package db

import (
	"fmt"
	"github.com/gomodule/redigo/redis"
	rg "github.com/redislabs/redisgraph-go"
	"strings"
	"time"
)

var (
	pool *redis.Pool
)

func newPool(addr string) *redis.Pool {
	return &redis.Pool{
		MaxActive:   1024,
		IdleTimeout: 240 * time.Second,
		// Dial or DialContext must be set. When both are set, DialContext takes precedence over Dial.
		Dial: func() (redis.Conn, error) { return redis.Dial("tcp", addr) },
	}
}

func Init(addr string) {
	pool = newPool(addr)
}

func GetUser(login string) (string, error) {
	conn := pool.Get()
	defer conn.Close()
	res, err := conn.Do("HGET", "users", login)
	if err != nil {
		return "", err
	}
	if res != nil {
		resStr, ok := res.(string)
		if ok {
			return resStr, err
		}
		resUint, ok := res.([]uint8)
		if ok {
			return string(resUint), err
		}
	}
	return "", err
}

func AddUser(login string, password string) error {
	conn := pool.Get()
	defer conn.Close()
	_, err := conn.Do("HSET", "users", login, password)
	return err
}

func userNode(username string) *rg.Node {
	return &rg.Node{
		Label: "User",
		Properties: map[string]interface{}{
			"username": username,
		},
	}
}

func graph() (*rg.Graph, func()) {
	conn := pool.Get()
	g, d := rg.GraphNew("planetzor", conn), func() {
		conn.Close()
	}
	return &g, d
}

func AddReview(review Review) error {
	graph, c := graph()
	defer c()

	n := rg.Node{
		Label: "Review",
		Properties: map[string]interface{}{
			"content": review.Content,
			"author":  review.Author,
			"score":   review.Score,
			"private": review.Private,
			"planet":  review.Planet,
			"created": int(time.Now().Unix()),
		},
	}
	graph.AddNode(&n)
	source := userNode(review.Author)
	graph.AddNode(source)

	authorEdge := rg.Edge{
		Relation:    "Wrote",
		Source:      source,
		Destination: &n,
	}

	err := graph.AddEdge(&authorEdge)
	if err != nil {
		return err
	}
	_, err = graph.Commit()
	return err
}

func graphQuery(g *rg.Graph, q string, val ...interface{}) (*rg.QueryResult, error) {
	for index, v := range val {
		stringVal, ok := v.(string)
		if ok {
			stringVal = strings.ReplaceAll(stringVal, `"`, `\"`)
			val[index] = stringVal
		}
	}
	parsedQuery := fmt.Sprintf(q, val...)
	return g.Query(parsedQuery)
}

func parseReviews(result *rg.QueryResult) (rws []Review) {
	for result.Next() {
		r, ok := result.Record().Get("r")
		if !ok {
			continue
		}

		row, ok := r.(*rg.Node)
		if !ok {
			continue
		}

		content := row.Properties["content"]
		author := row.Properties["author"]
		score := row.Properties["score"]
		private := row.Properties["private"]
		planet := row.Properties["planet"]
		rws = append(rws, Review{
			Author:  author.(string),
			Score:   score.(int),
			Planet:  planet.(string),
			Content: content.(string),
			Private: private.(bool),
		})
	}
	return
}

func UserReviews(login string) []Review {
	g, c := graph()
	defer c()

	query := `MATCH (u:User {username: "%s"})-[:Wrote]->(r:Review) RETURN r`
	result, err := graphQuery(g, query, login)
	if err != nil {
		return nil
	}
	return parseReviews(result)
}

func PublicReviews(planet string, rating string, limit int) []Review {
	g, c := graph()
	defer c()

	q := `MATCH (r:Review {private: FALSE})`
	if planet != "" {
		q = fmt.Sprintf(`MATCH (r:Review {private: FALSE, planet: "%s"})`, planet)
	}
	if rating != "" {
		q += fmt.Sprintf(` WHERE r.score = %s`, rating)
	}
	q += fmt.Sprintf(` RETURN r ORDER BY r.created DESC LIMIT %d`, limit)
	result, err := g.Query(q)
	if err != nil {
		return nil
	}
	return parseReviews(result)
}

func ListPlanetScores() map[string]float64 {
	g, c := graph()
	defer c()
	q := `MATCH (r:Review {private:FALSE}) RETURN r.planet, AVG(r.score) ORDER BY AVG(r.score) DESC`
	result, err := graphQuery(g, q)
	if err != nil {
		return nil
	}
	res := make(map[string]float64)
	for result.Next() {
		planet, pOk := result.Record().Get("r.planet")
		score, sOk := result.Record().Get("AVG(r.score)")
		if !pOk || !sOk {
			continue
		}
		planetName := planet.(string)
		planetScore := score.(float64)
		res[planetName] = planetScore
	}
	return res

}

func SubscribeReviews(login string) []Review {
	g, c := graph()
	defer c()

	userResults, err := graphQuery(g,
		`MATCH (u:User {username: "%s"})-[:Follower]->(a:User) RETURN a.username`, login)
	if err != nil {
		return nil
	}

	subscriptions := make(map[string]struct{})
	for userResults.Next() {
		username, ok := userResults.Record().Get("a.username")
		if !ok {
			continue
		}
		usrString, ok := username.(string)
		if !ok {
			continue
		}
		usrString = strings.ReplaceAll(usrString, `"`, `\"`)
		if _, ok := subscriptions[usrString]; !ok {
			subscriptions[usrString] = struct{}{}
		}
	}

	var inFilter strings.Builder
	inFilter.WriteString("[")
	i := 0
	for v := range subscriptions {
		if i != 0 {
			inFilter.WriteString(",")
		}
		inFilter.WriteString(fmt.Sprintf(`"%s"`, v))
		i++
	}
	inFilter.WriteString("]")

	q := `MATCH (u:User)-[:Wrote]->(r:Review) WHERE u.username IN ` + inFilter.String() +
		` RETURN r ORDER BY r.created DESC LIMIT 50`
	result, err := g.Query(q)

	if err != nil {
		return nil
	}

	return parseReviews(result)
}

func AddFollower(creator string, follower string) error {
	g, c := graph()
	defer c()

	from := userNode(follower)
	to := userNode(creator)
	g.AddNode(from)
	g.AddNode(to)

	authorEdge := &rg.Edge{
		Relation:    "Follower",
		Source:      from,
		Destination: to,
	}

	g.AddEdge(authorEdge)

	_, err := g.Commit()

	return err
}
