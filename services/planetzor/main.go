package main

import (
	"crypto/rand"
	"github.com/gorilla/sessions"
	"github.com/labstack/echo-contrib/session"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"html/template"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"planetzor/db"
	"planetzor/tokens"
	"strconv"
)

type Template struct {
	templates *template.Template
}

func (t *Template) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	return t.templates.ExecuteTemplate(w, name, data)
}

type ErrorContext struct {
	Error string
}

type PlanetContext struct {
	Planets []string
	ErrorContext
}

type ReviewContext struct {
	Reviews []db.Review
}

type HomeContext struct {
	ReviewContext
	Token string
	User  string
}

type PublicReviewsContext struct {
	ReviewContext
	PlanetContext
	Planet string
	Score  string
	Scores []string
}

func loginSession(c echo.Context, login string) *sessions.Session {
	sess, _ := session.Get("session", c)
	sess.Values["login"] = login
	sess.Options = &sessions.Options{
		Path:   "/",
		MaxAge: 86400 * 7,
	}
	sess.Values["login"] = login
	return sess
}

func getLoginFromSession(c echo.Context) string {
	sess, _ := session.Get("session", c)
	login, exists := sess.Values["login"]
	if !exists {
		return ""
	}
	return login.(string)
}

func registerPage(c echo.Context) error {
	return c.Render(http.StatusOK, "register", nil)
}

func loginPage(c echo.Context) error {
	return c.Render(http.StatusOK, "login", nil)
}

func addReviewPage(c echo.Context) error {
	return c.Render(http.StatusOK, "addReview", PlanetContext{
		Planets: db.ListPlanets(),
	})
}

func homePage(c echo.Context) error {
	ctx := HomeContext{}
	login := getLoginFromSession(c)
	ctx.Reviews = db.UserReviews(login)
	ctx.Token = tokens.GenerateToken(login)
	ctx.User = login
	return c.Render(http.StatusOK, "home", ctx)
}

func feedPage(c echo.Context) error {
	ctx := ReviewContext{}
	ctx.Reviews = db.SubscribeReviews(getLoginFromSession(c))
	return c.Render(http.StatusOK, "feed", ctx)
}

func latestReviews(c echo.Context) error {
	planet := c.QueryParam("planet")
	if planet != "" && !db.ValidatePlanet(planet) {
		return c.HTML(http.StatusUnprocessableEntity, "Bad Planet")
	}

	score := c.QueryParam("score")
	if score != "" && !db.ValidateScore(score) {
		return c.HTML(http.StatusUnprocessableEntity, "Bad Score")
	}

	ctx := PublicReviewsContext{}
	ctx.Reviews = db.PublicReviews(planet, score, 150)
	ctx.Score = score
	ctx.Planet = planet
	ctx.Planets = db.ListPlanets()
	ctx.Scores = []string{"1", "2", "3", "4", "5"}
	return c.Render(http.StatusOK, "latestReviews", ctx)
}

func listPage(c echo.Context) error {
	return c.Render(http.StatusOK, "list", db.ListPlanetScores())
}

func handleRegister(c echo.Context) error {
	login := c.FormValue("login")
	password := c.FormValue("password")
	if login == "" || password == "" {
		return c.Render(http.StatusUnprocessableEntity, "register",
			ErrorContext{"please provide login and password"},
		)
	}
	p, err := db.GetUser(login)
	if err != nil || p != "" {
		resp := ErrorContext{"user with such login already exists"}
		if err != nil {
			resp.Error += err.Error()
		}
		return c.Render(http.StatusUnprocessableEntity, "register", resp)
	}
	err = db.AddUser(login, password)
	if err != nil {
		return c.Render(http.StatusUnprocessableEntity, "register",
			ErrorContext{err.Error()},
		)
	}

	sess := loginSession(c, login)
	if err := sess.Save(c.Request(), c.Response()); err != nil {
		return c.Render(http.StatusUnprocessableEntity, "register",
			ErrorContext{err.Error()},
		)
	}
	return c.Redirect(http.StatusFound, "/home")
}

func handleLogin(c echo.Context) error {
	login := c.FormValue("login")
	password := c.FormValue("password")
	if login == "" || password == "" {
		return c.Render(http.StatusUnprocessableEntity, "login",
			ErrorContext{"please provide login and password"},
		)
	}
	p, err := db.GetUser(login)
	if err != nil {
		return c.Render(http.StatusUnprocessableEntity, "login",
			ErrorContext{err.Error()},
		)
	}
	if p != password {
		return c.Render(http.StatusUnprocessableEntity, "login",
			ErrorContext{"failed to find user with this login and password"},
		)
	}

	sess := loginSession(c, login)
	if err := sess.Save(c.Request(), c.Response()); err != nil {
		return c.Render(http.StatusUnprocessableEntity, "login",
			ErrorContext{err.Error()},
		)
	}
	return c.Redirect(http.StatusFound, "/home")
}

func handleAddReview(c echo.Context) error {
	u := getLoginFromSession(c)
	content := c.FormValue("content")
	planet := c.FormValue("planet")
	isPrivate := c.FormValue("private")
	score := c.FormValue("score")

	if !db.ValidateScore(score) {
		return c.Render(http.StatusUnprocessableEntity, "addReview",
			PlanetContext{db.ListPlanets(), ErrorContext{"Failed to validate score"}},
		)
	}

	if !db.ValidatePlanet(planet) {
		return c.Render(http.StatusUnprocessableEntity, "addReview",
			PlanetContext{db.ListPlanets(), ErrorContext{"Invalid planet"}},
		)
	}

	scoreInt, _ := strconv.Atoi(score)

	r := db.Review{
		Author:  u,
		Score:   scoreInt,
		Content: content,
		Private: isPrivate == "on",
		Planet:  planet,
	}

	err := db.AddReview(r)
	if err != nil {
		return c.Render(http.StatusUnprocessableEntity, "addReview",
			PlanetContext{db.ListPlanets(), ErrorContext{err.Error()}},
		)
	}

	return c.Redirect(http.StatusFound, "/")
}

func handleSubscribe(c echo.Context) error {
	user := c.QueryParam("user")
	self := getLoginFromSession(c)
	token := c.QueryParam("token")
	if self == user {
		return c.HTML(http.StatusForbidden, "your own token")
	}
	if tokens.CheckToken(user, token) {
		err := db.AddFollower(user, self)
		if err != nil {
			return c.HTML(http.StatusForbidden, err.Error())
		}
		return c.Redirect(http.StatusFound, "/feed")
	}
	return c.HTML(http.StatusForbidden, "invalid token")
}

func loginRequired(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		if login := getLoginFromSession(c); login == "" {
			return c.Redirect(http.StatusFound, "/login")
		}
		return next(c)
	}
}

func sessionToken(tokenFile string) ([]byte, error) {
	if _, err := os.Stat(tokenFile); err != nil && os.IsNotExist(err) {
		bytes := make([]byte, 30)
		rand.Read(bytes)
		if err = ioutil.WriteFile(tokenFile, bytes, 0644); err != nil {
			return nil, err
		}
	}
	key, err := ioutil.ReadFile(tokenFile)
	if err != nil {
		return nil, err
	}
	return key, err
}

func main() {
	db.Init("db:6379")
	if err := tokens.Init("/data/private.key"); err != nil {
		panic(err)
	}

	e := echo.New()
	sessionKey, err := sessionToken("/data/token.txt")
	if err != nil {
		panic(err)
	}
	e.Use(session.Middleware(sessions.NewCookieStore(sessionKey)))
	// Init views.
	t := &Template{
		templates: template.Must(template.ParseGlob("public/views/*.html")),
	}
	e.Renderer = t
	e.Use(middleware.Recover())

	e.GET("/", func(c echo.Context) error {
		if login := getLoginFromSession(c); login == "" {
			return c.Redirect(http.StatusFound, "/login")
		}
		return c.Redirect(http.StatusFound, "/home")
	})
	e.GET("/login", loginPage)
	e.POST("/login", handleLogin)
	e.GET("/register", registerPage)
	e.POST("/register", handleRegister)
	e.GET("/add", addReviewPage, loginRequired)
	e.POST("/add", handleAddReview, loginRequired)
	e.GET("/home", homePage, loginRequired)
	e.GET("/feed", feedPage, loginRequired)
	e.GET("/subscribe", handleSubscribe, loginRequired)
	e.GET("/planets", listPage)
	e.GET("/reviews", latestReviews)
	e.Debug = true
	e.Start(":4000")
}
