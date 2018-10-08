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

  test "creates user from Foursquare information", %{conn: conn} do
    conn
      |> assign(:ueberauth_auth, @user_auth)
      |> get("/auth/foursquare/callback")

    users = User |> Repo.all

    assert Enum.count(users) == 1
  end
end
