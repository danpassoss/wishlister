defmodule Wishlister.UserTest do
  use Wishlister.DataCase

  alias Wishlister.Accounts.User

  @valid_attrs %{
    email: "test@test.com",
    provider: "foursquare",
    token: "QWERTY12345",
    name: "Test",
    avatar: "http://avatar.url.com",
    provider_uid: 001002
  }

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "email is required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :email))
    refute changeset.valid?
  end

  test "provider is required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :provider))
    refute changeset.valid?
  end

  test "token is required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :token))
    refute changeset.valid?
  end

  test "name is required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :name))
    refute changeset.valid?
  end

  test "avatar is required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :avatar))
    refute changeset.valid?
  end

  test "provider_uid is required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :provider_uid))
    refute changeset.valid?
  end

  test "email must contain at least an @" do
    attrs = %{@valid_attrs | email: "testtest.com"}
    changeset = User.changeset(%User{}, attrs)
    assert %{email: ["has invalid format"]} = errors_on(changeset)
  end



end
