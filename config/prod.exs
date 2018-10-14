use Mix.Config

config :wishlister, WishlisterWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: "danwishlist.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

config :wishlister, Wishlister.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool_size: 18,
  ssl: true,
  url: System.get_env("DATABASE_URL")

# Set Foursquare Api Module to use in production
config(:wishlister, :foursquare_api, Wishlister.Api.Foursquare)
