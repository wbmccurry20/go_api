package main

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"log"
)

func main() {
	app := fiber.New()
	app.Use(cors.New())

	api := app.Group("/api")

	// test handler
	api.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("App Running")
	})

	log.Fatal(app.Listen(":8080"))
}
