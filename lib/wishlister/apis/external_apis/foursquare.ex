defmodule Wishlister.Api.Foursquare do

  defp base_url do
    "https://api.foursquare.com/v2"
  end

  defp join_today_date() do
    {{y, m, d}, _rest} = :calendar.local_time()
    "#{y}0#{m}#{d}"
  end

  defp venue_img_path_url(venue_id, token) do
    "/venues/#{venue_id}/photos?oauth_token=#{token}&v=#{join_today_date()}"
  end

  defp recent_friends_checkin_path_url(token) do
    "/checkins/recent?oauth_token=#{token}&limit=6&v=#{join_today_date()}"
  end
  def get_recent_friends_checkins(user_token) do
    user_token
    |> recent_friends_checkin_path_url
    |> get_request
    |> build_venue_friends_list(user_token)
  end

  defp get_request(path_url) do
    case HTTPoison.get(base_url() <> path_url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, parse_response(body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp parse_response(body) do
    body
      |> JSON.decode!()
  end

  defp build_venue_friends_list({:ok, %{"response" => %{"recent" => checkins}}}, user_token) do
    for checkin <- checkins do
      %{
        venue_pid: checkin["venue"]["id"],
        name: checkin["venue"]["name"],
        image_url: venue_img_request(checkin["venue"]["id"], user_token)
      }
    end
  end

  defp venue_img_request(venue_id, token) do
    case get_request(venue_img_path_url(venue_id, token)) do
      {:ok, response} ->
        build_venue_img_url(response)

      {:error, reason} ->
        IO.inspect(reason)
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

end
