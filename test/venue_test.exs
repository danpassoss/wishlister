defmodule Wishlister.VenueTest do
  use Wishlister.DataCase

  alias Wishlister.Checkins.Venue

  @valid_attrs %{
    name: "Local Name",
    image_url: "http://placehold.it",
    venue_pid: "55bba25699hh"
  }

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Venue.changeset(%Venue{}, @valid_attrs)
    assert  changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Venue.changeset(%Venue{}, @invalid_attrs)
    refute  changeset.valid?
  end

  test "name is required" do
    changeset = Venue.changeset(%Venue{}, Map.delete(@valid_attrs, :name))
    refute changeset.valid?
  end

  test "image_url is required" do
    changeset = Venue.changeset(%Venue{}, Map.delete(@valid_attrs, :image_url))
    refute changeset.valid?
  end

  test "venue_pid is required" do
    changeset = Venue.changeset(%Venue{}, Map.delete(@valid_attrs, :venue_pid))
    refute changeset.valid?
  end
end
