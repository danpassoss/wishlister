defmodule WishlisterWeb.ListController do
  use WishlisterWeb, :controller

  import Ecto.Query

  alias Wishlister.{Venue, Repo}
  alias WishlisterWeb.Checkins

  plug WishlisterWeb.Plugs.RequireAuth when action in [
    :list
  ]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def list(conn, _params) do
    wishlist =
      wishlist_query(conn.assigns[:user].id)
      |>Repo.all

    checkins = Checkins.recent_checkins(conn)
    render conn, "list.html", checkins: checkins, wishlist: wishlist
  end
  def wishlist_query(user_id) do
    from v in "venues",
    where: v.user_id == ^user_id,
    select: %Venue{id: v.id, name: v.name, image_url: v.image_url, venue_pid: v.venue_pid}
  end

  def create(conn, %{"checkin" => venue}) do
    changeset = conn.assigns.user
      |> Ecto.build_assoc(:venues)
      |> Venue.changeset(venue)
    case Repo.insert(changeset) do
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
    Repo.get!(Venue, venue_id) |> Repo.delete!

    conn
    |> put_flash(:info, "Venue removed from your wishlist!")
    |> redirect(to: list_path(conn, :list))
  end
end
