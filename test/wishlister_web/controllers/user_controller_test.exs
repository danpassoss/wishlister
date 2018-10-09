defmodule WishlisterWeb.UserControllerTest do
  use WishlisterWeb.ConnCase

  alias Wishlister.{Accounts, Accounts.User, Repo}

  @user_auth %{
    uid: "123456789",
    credentials: %{
      token: "QJJSIJD89AJDQKJ2MGJAJD00KDJAO02"
    },
    info: %{
      first_name: "User",
      email: "test@test.com",
      image: %{
        "prefix" => "https://user.image.com/",
        "suffix" => "image/user.png"
      },
    }
  }

  test "creates user from Foursquare information auth", %{conn: conn} do
    conn = conn
    |> assign(:ueberauth_auth, @user_auth)
    |> get(user_path(conn, :callback, "foursquare"))

    users = User |> Repo.all

    assert Enum.count(users) == 1
    assert redirected_to(conn, 302) == "/wishlist"
    assert get_flash(conn, :info) == "Welcome back!"
  end

  test "signs out user", %{conn: conn} do
    conn = conn
      |> assign(:user, @user_auth)
      |> get(user_path(conn, :signout))

    assert conn.assigns.user == nil
    assert redirected_to(conn, 302) == "/"
  end
end
