require IEx;
defmodule WishlisterWeb.ListController do
  use WishlisterWeb, :controller


  alias Wishlister.Checkins

  plug WishlisterWeb.Plugs.RequireAuth when action in [
    :list,
    :create,
    :delete
  ]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def list(conn, _params) do
    user = conn.assigns[:user]

    wishlist = Checkins.get_user_wishlist(user.id)

    friends_checkins =
      Checkins.recents_friends_checkins(user.token)
      |> Checkins.filter_not_added_venues(wishlist)

    render conn, "list.html", checkins: friends_checkins, wishlist: wishlist
  end

  def create(conn, %{"checkin" => venue}) do
    user = conn.assigns.user
    case Checkins.add_venue_to_wishlist(user, venue) do
      {:ok, _venue} ->
        conn
        |> put_flash(:info, "Venue added on your wishlist")
        |> redirect(to: list_path(conn, :list))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to add venue on your wishlist")
        |> redirect(to: list_path(conn, :list))
    end
  end

  def delete(conn, %{"id" => venue_id}) do
    Checkins.remove_venue_from_wishlist(venue_id)

    conn
    |> put_flash(:info, "Venue removed from your wishlist!")
    |> redirect(to: list_path(conn, :list))
  end
end
