defmodule WishlisterWeb.Router do
  use WishlisterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug WishlisterWeb.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WishlisterWeb do
    pipe_through :browser # Use the default browser stack

    get "/", VenueController, :index
    get "/wishlist", VenueController, :list
    post "/venues", VenueController, :create
    delete "/venues/:id", VenueController, :delete

  end

  scope "/auth", WishlisterWeb do
    pipe_through :browser

    get "/signout", UserController, :signout
    get "/:provider", UserController, :request
    get "/:provider/callback", UserController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", WishlisterWeb do
  #   pipe_through :api
  # end
end
