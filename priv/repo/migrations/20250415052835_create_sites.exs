defmodule LocationTracker.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :name, :string
      add :latitude, :float
      add :longitude, :float

      timestamps(type: :utc_datetime)
    end
  end
end
