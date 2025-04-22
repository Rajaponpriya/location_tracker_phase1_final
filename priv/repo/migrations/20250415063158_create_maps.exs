defmodule LocationTracker.Repo.Migrations.CreateMaps do
  use Ecto.Migration

  def change do
    create table(:maps) do

      timestamps(type: :utc_datetime)
    end
  end
end
