defmodule LocationTracker.Sites.Site do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :latitude, :longitude, :name]}

  schema "sites" do
    field :latitude, :float
    field :longitude, :float
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:name, :latitude, :longitude])
    |> validate_required([:name, :latitude, :longitude])
  end
end
