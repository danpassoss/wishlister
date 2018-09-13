defmodule Wishlister.Repo.Migrations.CreateVenues do
  use Ecto.Migration

  def change do
    create table(:venues) do
      add :name, :string
      add :image_url, :string
      add :venue_pid, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:venues, [:user_id])
  end
end
