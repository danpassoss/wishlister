defmodule WishlisterWeb.VenueControllerTest do
  use WishlisterWeb.ConnCase
  use Plug.Test

  alias Wishlister.{
    Accounts,
    Checkins,
  }

  @user_info %{
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

  @venue_params %{
    "checkin" => %{
      image_url: "http://placehold.it/300x300",
      name: "Venue Mock 1",
      venue_pid: "5ze147895e7o6598f4b1432657"
    }
  }


  test "GET /index, should shows a button with signin information", %{conn: conn} do
    assert html_response(get(conn, venue_path(conn, :index)), 200) =~ "Sign in with Foursquare"
  end

  describe "tests venue_controller actions that require a user" do

    setup [:configure_user_connection]

    test "GET /list, should shows an empty user wishlist and recent friends checkins", %{conn: conn} do
      conn = conn
        |> get(venue_path(conn, :list))

      assert html_response(conn, 200) =~  "User wishlist", "Recents Friends Checkins"
      assert conn
        |> get_user_id
        |> get_wishlist == []
    end

    test "GET /list, should not be allowed, if the user is not authenticated", %{conn: conn} do
      conn = conn
        |> drop_user_from_connection
        |> get(venue_path(conn, :list))

        assert redirected_to(conn, 302) == "/"
        assert get_flash(conn, :error) == "You must be logged in."
    end

    test "POST /create, should add a venue to user wishlist", %{conn: conn} do
      conn = conn
        |> post(venue_path(conn, :create, @venue_params))


      assert redirected_to(conn, 302) == "/wishlist"
      assert get_flash(conn, :info) == "Venue added on your wishlist"
      assert conn
        |> get_user_id
        |> get_wishlist
        |> Enum.count == 1
    end

    test "POST /create, should not be allowed, if the user is not authenticated", %{conn: conn} do
      conn = conn
        |> drop_user_from_connection
        |> post(venue_path(conn, :create, @venue_params))

        assert redirected_to(conn, 302) == "/"
        assert get_flash(conn, :error) == "You must be logged in."
    end

    test "DELETE /delete, should remove a venue from user wishlist", %{conn: conn} do
      %{"checkin" => venue_info}  = @venue_params
      {:ok, venue} = Checkins.add_venue_to_wishlist(conn.assigns[:user], venue_info)

      conn = conn
        |> delete(venue_path(conn, :delete, venue.id))

        assert redirected_to(conn, 302) == "/wishlist"
        assert get_flash(conn, :info) == "Venue removed from your wishlist!"
        assert conn
          |> get_user_id
          |> get_wishlist == []
    end

    test "DELETE /delete, should not be allowed, if the user is not authenticated", %{conn: conn} do
      %{"checkin" => venue_info}  = @venue_params
      {:ok, venue} = Checkins.add_venue_to_wishlist(conn.assigns[:user], venue_info)

      conn = conn
        |> drop_user_from_connection
        |> delete(venue_path(conn, :delete, venue.id))

      assert redirected_to(conn, 302) == "/"
      assert get_flash(conn, :error) == "You must be logged in."
    end
  end

  defp configure_user_connection(_) do
    user = create_user()
    conn = build_conn()
      |> init_test_session(user_id: user.id)
      |> assign(:user, user)
    {:ok, conn: conn}
  end

  defp drop_user_from_connection(conn) do
    update_in(conn.assigns, &Map.drop(&1, [:user]))
    |> clear_session()
  end

  defp create_user do
    {:ok, user} = Accounts.sign_in_user(@user_info, "foursquare")
    user
  end

  defp get_wishlist(user_id) do
    Checkins.get_user_wishlist(user_id)
  end

  defp get_user_id(conn) do
    conn.assigns[:user].id
  end
end
