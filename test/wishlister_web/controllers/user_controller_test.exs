defmodule WishlisterWeb.UserControllerTest do
  use WishlisterWeb.ConnCase

  alias Wishlister.Accounts

  # test "callback/2 responds with user signin", %{conn: conn} do
  #   user = %{
  #     uid: "123456789",
  #     credentials: %{
  #       token: "QJJSIJD89AJDQKJ2MGJAJD00KDJAO02"
  #     },
  #     info: %{
  #       first_name: "User",
  #       email: "test@test.com",
  #       image: %{
  #         prefix: "https://user.image.com/",
  #         suffix: "image/user.png"
  #       },
  #     }
  #   }

  #   provider = "foursquare"

  #   response =
  #     conn
  #     |> get(user_path(conn, :callback, user))
  #     |> json_response(200)

  #   assert response == redirect(to: venue_path(conn, :list))
  # end
end
