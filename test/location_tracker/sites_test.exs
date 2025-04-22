defmodule LocationTracker.SitesTest do
  use LocationTracker.DataCase

  alias LocationTracker.Sites

  describe "maps" do
    alias LocationTracker.Sites.Map

    import LocationTracker.SitesFixtures

    @invalid_attrs %{}

    test "list_maps/0 returns all maps" do
      map = map_fixture()
      assert Sites.list_maps() == [map]
    end

    test "get_map!/1 returns the map with given id" do
      map = map_fixture()
      assert Sites.get_map!(map.id) == map
    end

    test "create_map/1 with valid data creates a map" do
      valid_attrs = %{}

      assert {:ok, %Map{} = map} = Sites.create_map(valid_attrs)
    end

    test "create_map/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sites.create_map(@invalid_attrs)
    end

    test "update_map/2 with valid data updates the map" do
      map = map_fixture()
      update_attrs = %{}

      assert {:ok, %Map{} = map} = Sites.update_map(map, update_attrs)
    end

    test "update_map/2 with invalid data returns error changeset" do
      map = map_fixture()
      assert {:error, %Ecto.Changeset{}} = Sites.update_map(map, @invalid_attrs)
      assert map == Sites.get_map!(map.id)
    end

    test "delete_map/1 deletes the map" do
      map = map_fixture()
      assert {:ok, %Map{}} = Sites.delete_map(map)
      assert_raise Ecto.NoResultsError, fn -> Sites.get_map!(map.id) end
    end

    test "change_map/1 returns a map changeset" do
      map = map_fixture()
      assert %Ecto.Changeset{} = Sites.change_map(map)
    end
  end
end
