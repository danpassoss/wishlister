defmodule Wishlister.Checkins do

  import Ecto.Query

  alias Wishlister.{
    Api.Foursquare,
    Checkins.Venue,
    Repo
  }


  def get_user_wishlist(user_id) do
    Repo.all(user_wishlist_query(user_id))
  end

  def recents_friends_checkins(user_token) do
    user_token
      |> Foursquare.get_recent_friends_checkins
  end

  def add_venue_to_wishlist(user, venue) do
    user
    |> Ecto.build_assoc(:venues)
    |> Venue.changeset(venue)
    |> Repo.insert
  end

  def remove_venue_from_wishlist(venue_id) do
    Repo.get!(Venue, venue_id)
    |> Repo.delete!
  end

  def filter_not_added_venues(checkins, wishlist) do
    venues_pids = Enum.map(wishlist, & &1.venue_pid)
    Enum.filter(checkins, & &1.venue_pid not in venues_pids)
  end

  defp user_wishlist_query(user_id) do
    from v in "venues",
    where: v.user_id == ^user_id,
    select: %Venue{id: v.id, name: v.name, image_url: v.image_url, venue_pid: v.venue_pid}
  end

end
