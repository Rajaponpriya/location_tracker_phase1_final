defmodule LocationTracker.SitesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LocationTracker.Sites` context.
  """

  @doc """
  Generate a map.
  """
  def map_fixture(attrs \\ %{}) do
    {:ok, map} =
      attrs
      |> Enum.into(%{

      })
      |> LocationTracker.Sites.create_map()

    map
  end
end
