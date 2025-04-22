defmodule LocationTracker.Sites.Map do
  use Ecto.Schema
  import Ecto.Changeset

  schema "maps" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(map, attrs) do
    map
    |> cast(attrs, [])
    |> validate_required([])
  end
end
