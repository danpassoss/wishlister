# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wishlister,
  ecto_repos: [Wishlister.Repo]

# Configures the endpoint
config :wishlister, WishlisterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vNXneLbc5bR2TftSZ5pCuQuj/MXhEg+xvIlbbrOHtVeLyIzxn47qdduaR82lbHch",
  render_errors: [view: WishlisterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Wishlister.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :ueberauth, Ueberauth,
  providers: [
    foursquare: { Ueberauth.Strategy.Foursquare, [] }
  ]
config :ueberauth, Ueberauth.Strategy.Foursquare.OAuth,
  client_id: "MDXX3FXL4BNTRNNN4T4CTKEJXMYWFVZV0DTIK0F3K1DWSJOF",
  client_secret: "EUWVUBSOJDQMVQRFQJBZIK1UXWIJC5TNUGAOIZWUX4OAHHF5"
