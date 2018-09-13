defmodule Wishlister.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :provider, :string
      add :token, :string
      add :name, :string
      add :avatar, :string
      add :provider_uid, :integer

      timestamps()
    end

  end
end
