defmodule Wishlister.Venue do
  use Ecto.Schema
  import Ecto.Changeset


  schema "venues" do
    field :image_url, :string
    field :name, :string
    field :venue_pid, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(venue, attrs) do
    venue
    |> cast(attrs, [:name, :image_url, :venue_pid])
    |> validate_required([:name, :image_url, :venue_pid])
  end
end
