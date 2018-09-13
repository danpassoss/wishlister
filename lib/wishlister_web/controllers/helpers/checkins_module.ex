defmodule WishlisterWeb.Checkins do

  def recent_checkins(conn) do
    user_token = conn.assigns[:user].token
      user_token
      |> recent_friends_checkin_suffix
      |> make_request(user_token)
  end

  def make_request(url, user_token) do
    case HTTPoison.get("https://api.foursquare.com/v2/" <> url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        parse_response(body)
        |> build_venue_friends_list(user_token)

      {:error, %HTTPoison.Error{reason: _reason}} ->

    end
  end

  def parse_response(body) do
    body
    |> JSON.decode!()
  end

  def build_venue_friends_list(%{"response" => %{"recent" => checkins}}, user_token) do
    checkins_list =
      for checkin <- checkins do
        %{
          venue_pid: 1234567,#checkin["venue"]["id"],
          name: "Local",#checkin["venue"]["name"],
          image_url: "https://cdn.leroymerlin.com.br/products/tela_paisagem_praia_30x30cm_89317571_0001_300x300.jpg" #venue_img_request(checkin["venue"]["id"], user_token)
        }
      end
  end

  def venue_img_request(venue_id, token) do
    url = "https://api.foursquare.com/v2/venues/#{venue_id}/photos?oauth_token=#{token}&v=#{join_today_date()}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        parse_response(body)
        |> build_venue_img_url
      {:error, %HTTPoison.Error{reason: _reason}} ->

      end
  end

  def build_venue_img_url(%{"response" => %{"photos" => %{"items" => items}}}) do
    case length(items) do
      1 ->
        "#{List.first(items)["prefix"]}300x300#{List.first(items)["suffix"]}"
      0 ->
        "http://placehold.it/300x300"
    end
  end

  def join_today_date() do
    {{y, m, d}, _rest} = :calendar.local_time()
    "#{y}0#{m}#{d}"
  end

  def recent_friends_checkin_suffix(token) do
    "checkins/recent?oauth_token=#{token}&limit=10&v=#{join_today_date()}"
  end
end