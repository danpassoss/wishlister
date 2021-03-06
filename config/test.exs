use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wishlister, WishlisterWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :wishlister, Wishlister.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "252489",
  database: "wishlister_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Set Foursquare Api Module to use in test
config(:wishlister, :foursquare_api, Wishlister.Api.Foursquare.Mock)
