defmodule Wishlister.CheckinsTest do
  use Wishlister.DataCase

  alias Wishlister.Checkins
  alias Wishlister.{Accounts, Accounts.User}

  @user %{
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

  @venue %{
    image_url: "https://venue.image/image.png",
    name: "Venue Test",
    venue_pid: "12123154sda",
  }

  describe "checkins public functions" do
    setup [:return_user]
    test "should add venue to user wishlist", %{user: user} do
      response = Checkins.add_venue_to_wishlist(user, @venue)
      assert  {:ok, venue} = response
    end

    test "should return an empty user wishlist", %{user: user} do
      wishlist = Checkins.get_user_wishlist(user.id)
      assert is_list(wishlist)
      assert wishlist == []
    end

    test "shouldn't return an empty user wishlist", %{user: user} do
      Checkins.add_venue_to_wishlist(user, @venue)
      wishlist = Checkins.get_user_wishlist(user.id)
      assert is_list(wishlist)
      refute wishlist == []
    end

    test "should return recents friends checkins", %{user: user} do
      response = Checkins.recents_friends_checkins(user.token)
      assert is_list(response)
      assert Enum.count(response) > 0
    end

  end

  defp return_user(_) do
    {:ok, struct} = Accounts.sign_in_user(@user, "foursquare")

    %{user: struct}
  end

end
