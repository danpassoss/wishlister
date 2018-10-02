defmodule Wishlister.CheckinsTest do
  use Wishlister.DataCase

  alias Wishlister.Checkins
  alias Wishlister.{Accounts, Accounts.User}

  @user %{
    avatar: "https://user.avatar/image.png",
    email: "user@test.com",
    name: "User",
    provider: "foursquare",
    provider_uid: 123456789,
    token: "ASDOKK89KDOAKS82HDD21NM0021"
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

    test "should return an empty wishlist", %{user: user} do
      wishlist = Checkins.get_user_wishlist(user.id)
      assert is_list(wishlist)
      assert wishlist == []
    end

    test "shouldn't return an empty wishlist", %{user: user} do
      Checkins.add_venue_to_wishlist(user, @venue)
      wishlist = Checkins.get_user_wishlist(user.id)
      assert is_list(wishlist)
      refute wishlist == []
    end

    test "test", %{user: user} do
      response = Checkins.recents_friends_checkins(user.token)
      assert is_list(response)
    end

  end

  defp return_user(_) do
    {:ok, struct} =
    User.changeset(%User{}, @user)
    |> Accounts.insert_or_update_user

    %{user: struct}
  end

end
