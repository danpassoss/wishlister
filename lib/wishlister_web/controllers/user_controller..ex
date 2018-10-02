defmodule WishlisterWeb.UserController do
  use WishlisterWeb, :controller

  plug Ueberauth

  alias Wishlister.Accounts

  def callback(%{ assigns: %{ ueberauth_auth: user_info } } = conn,
                %{"provider" => provider}) do
    case Accounts.sign_in_user(user_info, provider) do
      { :ok, user } ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: venue_path(conn, :list))
      { :error, _reason } ->
        conn
        |> put_flash(:error, "Error sign in")
        |> redirect(to: venue_path(conn, :index))
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: venue_path(conn, :index))
  end
end
