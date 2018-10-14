defmodule Wishlister.Api.Foursquare.Mock do

  def get_recent_friends_checkins(_user_token) do
    [
      %{
        image_url: "http://placehold.it/300x300",
        name: "Venue Mock 1",
        venue_pid: "5ze147895e7o6598f4b1432657"
      },
      %{
        image_url: "http://placehold.it/300x300",
        name: "Venue Mock 2",
        venue_pid: "4fe46999e4b037f4b6283234"
      }
    ]
  end
end
