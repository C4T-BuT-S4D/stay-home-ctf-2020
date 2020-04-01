package main

import (
	"fmt"
	"github.com/gorilla/sessions"
	"github.com/labstack/echo-contrib/session"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"html/template"
	"io"
	"net/http"
	"planetzor/db"
	"strconv"
)

type Template struct {
	templates *template.Template
}

func (t *Template) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	return t.templates.ExecuteTemplate(w, name, data)
}

type ErrorResponse struct {
	Error string
}

type PlanetContext struct {
	Planets []string
	ErrorResponse
}

type ReviewContext struct {
	Reviews []db.Review
}

type HomeContext struct {
	ReviewContext
	Token string
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
	ctx.Reviews = db.UserReviews(getLoginFromSession(c))
	fmt.Println(ctx)
	return c.Render(http.StatusOK, "home", ctx)
}

func feedPage(c echo.Context) error {
	ctx := ReviewContext{}
	ctx.Reviews = db.SubscribeReviews(getLoginFromSession(c))
	return c.Render(http.StatusOK, "feed", ctx)
}

func planetPage(c echo.Context) error {
	planet := c.QueryParam("planet")
	if !db.ValidatePlanet(planet) {
		return c.HTML(http.StatusNotFound, "404. <b>Planet not found.</b>")
	}
	ctx := ReviewContext{}
	ctx.Reviews = db.PlanetReviews(planet)
	return c.Render(http.StatusOK, "planet", ctx)
}

func listPage(c echo.Context) error {
	return c.Render(http.StatusOK, "list", db.ListPlanetScores())
}

func handleRegister(c echo.Context) error {
	login := c.FormValue("login")
	password := c.FormValue("password")
	if login == "" || password == "" {
		return c.Render(http.StatusUnprocessableEntity, "register",
			ErrorResponse{"please provide login and password"},
		)
	}
	p, err := db.GetUser(login)
	if err != nil || p != "" {
		resp := ErrorResponse{"user with such login already exists"}
		if err != nil {
			resp.Error += err.Error()
		}
		return c.Render(http.StatusUnprocessableEntity, "register", resp)
	}
	err = db.AddUser(login, password)
	if err != nil {
		return c.Render(http.StatusUnprocessableEntity, "register",
			ErrorResponse{err.Error()},
		)
	}

	sess := loginSession(c, login)
	if err := sess.Save(c.Request(), c.Response()); err != nil {
		return c.Render(http.StatusUnprocessableEntity, "register",
			ErrorResponse{err.Error()},
		)
	}
	return c.Redirect(http.StatusFound, "/home")
}

func handleLogin(c echo.Context) error {
	login := c.FormValue("login")
	password := c.FormValue("password")
	if login == "" || password == "" {
		return c.Render(http.StatusUnprocessableEntity, "login",
			ErrorResponse{"please provide login and password"},
		)
	}
	p, err := db.GetUser(login)
	if err != nil {
		return c.Render(http.StatusUnprocessableEntity, "login",
			ErrorResponse{err.Error()},
		)
	}
	if p != password {
		return c.Render(http.StatusUnprocessableEntity, "login",
			ErrorResponse{"failed to find user with this login and password"},
		)
	}

	sess := loginSession(c, login)
	if err := sess.Save(c.Request(), c.Response()); err != nil {
		return c.Render(http.StatusUnprocessableEntity, "login",
			ErrorResponse{err.Error()},
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
	scoreInt, err := strconv.Atoi(score)

	if err != nil {
		return c.Render(http.StatusUnprocessableEntity, "addReview",
			PlanetContext{db.ListPlanets(), ErrorResponse{err.Error()}},
		)
	}

	r := db.Review{
		Author:  u,
		Score:   scoreInt,
		Content: content,
		Private: isPrivate == "on",
		Planet:  planet,
	}

	if !db.ValidateReview(r) {
		return c.Render(http.StatusUnprocessableEntity, "addReview",
			PlanetContext{db.ListPlanets(), ErrorResponse{"invalid data"}},
		)
	}

	err = db.AddReview(r)
	if err != nil {
		return c.Render(http.StatusUnprocessableEntity, "addReview",
			PlanetContext{db.ListPlanets(), ErrorResponse{err.Error()}},
		)
	}

	// OK.
	return c.Redirect(http.StatusFound, "/")
}

func loginRequired(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		if login := getLoginFromSession(c); login == "" {
			return c.Redirect(http.StatusFound, "/login")
		}
		return next(c)
	}
}

func main() {
	db.Init("localhost:6379")

	e := echo.New()
	e.Use(session.Middleware(sessions.NewCookieStore([]byte("secret"))))
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
	e.GET("/planets", listPage)
	e.Debug = true
	e.Start(":4000")
}
