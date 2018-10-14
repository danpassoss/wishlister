defmodule WishlisterWeb.VenueControllerTest do
  use WishlisterWeb.ConnCase
  use Plug.Test

  alias Wishlister.{
    Accounts,
    Accounts.User,
    Checkins,
    Checkins.Venue,
    Repo
  }

  @create_user_attrs %User{}
    |> User.changeset%{
        avatar: "https://avatar.com/user.png",
        email: "user@email.com",
        name: "User Test",
        provider: "foursquare",
        provider_uid: 000001,
        token: "ASD8AJJAWWWMFNFB1233MAMDNAAOKSKDJ9"
      }


  describe "test venue_controller endpoints" do

    setup [:create_user]

    test "GET /index, should shows an button with signin information", %{conn: conn} do
      assert html_response(get(conn, venue_path(conn, :index)), 200) =~ "Sign in with Foursquare"
    end

    test "GET /list, should shows user wishlist and recent friends checkins", %{conn: conn, user: user} do
      conn = conn
        |> init_test_session(user_id: user.id)
        |> assign(:user, user)
        |> get(venue_path(conn, :list))

      assert html_response(conn, 200) =~  "User wishlist", "Recents Friends Checkins"
    end
  end

  defp create_user(_) do
    {:ok, user} = Accounts.insert_or_update_user(@create_user_attrs)
    {:ok, user: user}
  end
end
