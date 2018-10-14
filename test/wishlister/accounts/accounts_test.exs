defmodule Wishlister.AccountsTest do
  use Wishlister.DataCase

  alias Wishlister.Accounts

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

  test "should create a user" do
    user = Accounts.sign_in_user(@user, "provider")
    assert {:ok, user} = user
  end
end
