defmodule Wishlister.Checkins do

  import Ecto.Query

  alias Wishlister.{
    Checkins.Venue,
    Repo
  }


  def get_user_wishlist(user_id) do
    Repo.all(user_wishlist_query(user_id))
  end

  def recents_friends_checkins(user_token) do
    user_token
      |> recent_friends_checkin_suffix
      |> make_request(user_token)
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

  defp make_request(suffix, user_token) do
    case HTTPoison.get("https://api.foursquare.com/v2/" <> suffix) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        parse_response(body)
        |> build_venue_friends_list(user_token)

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason) #Clean warning: A expression is always required...
    end
  end

  defp parse_response(body) do
    body
    |> JSON.decode!()
  end

  defp build_venue_friends_list(%{"response" => %{"recent" => checkins}}, user_token) do
      for checkin <- checkins do
        %{
          venue_pid: checkin["venue"]["id"],
          name: checkin["venue"]["name"],
          image_url: venue_img_request(checkin["venue"]["id"], user_token)
        }
      end
  end

  defp venue_img_request(venue_id, token) do
    url = "https://api.foursquare.com/v2/venues/#{venue_id}/photos?oauth_token=#{token}&v=#{join_today_date()}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        parse_response(body)
        |> build_venue_img_url
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason) #Clean warning: A expression is always required...
      end
  end

  defp build_venue_img_url(%{"response" => %{"photos" => %{"items" => items}}}) do
    case length(items) do
      0 ->
        "http://placehold.it/300x300"
      _ ->
        "#{List.first(items)["prefix"]}300x300#{List.first(items)["suffix"]}"
      end
  end

  defp join_today_date() do
    {{y, m, d}, _rest} = :calendar.local_time()
    "#{y}0#{m}#{d}"
  end

  defp recent_friends_checkin_suffix(token) do
    "checkins/recent?oauth_token=#{token}&limit=6&v=#{join_today_date()}"
  end
end
