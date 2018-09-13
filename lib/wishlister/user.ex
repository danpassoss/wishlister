defmodule Wishlister.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :avatar, :string
    field :email, :string
    field :name, :string
    field :provider, :string
    field :provider_uid, :integer
    field :token, :string
    has_many :venues, Wishlister.Venue

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :provider, :token, :name, :avatar, :provider_uid])
    |> validate_required([:email, :provider, :token, :name, :avatar, :provider_uid])
    |> validate_format(:email, ~r/@/)
  end
end
