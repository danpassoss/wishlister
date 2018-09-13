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

    get "/", ListController, :index
    get "/wishlist", ListController, :list
    post "/venues", ListController, :create
    delete "/venues/:id", ListController, :delete

  end

  scope "/auth", WishlisterWeb do
    pipe_through :browser

    get "/signout", AuthController, :signout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", WishlisterWeb do
  #   pipe_through :api
  # end
end
