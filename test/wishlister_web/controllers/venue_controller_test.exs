defmodule WishlisterWeb.VenueControllerTest do
  use WishlisterWeb.ConnCase

  test "GET /", %{conn: conn} do
    assert html_response(get(conn, "/"), 200) =~ "Sign in with Foursquare"
  end

  # test "create/2 responds with venue created", %{conn: conn} do
  #   params = %{
  #     "checkin" => {
  #       image_url: "http://image.com/image.png"
  #       name: "Venue"
  #       venue_pid: "11218446821"
  #       user_id: "1"
  #     }
  #   }
  # end
end
