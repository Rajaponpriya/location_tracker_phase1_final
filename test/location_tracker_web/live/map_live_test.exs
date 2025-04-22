defmodule LocationTrackerWeb.MapLiveTest do
  use LocationTrackerWeb.ConnCase

  import Phoenix.LiveViewTest
  import LocationTracker.SitesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_map(_) do
    map = map_fixture()
    %{map: map}
  end

  describe "Index" do
    setup [:create_map]

    test "lists all maps", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/maps")

      assert html =~ "Listing Maps"
    end

    test "saves new map", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/maps")

      assert index_live |> element("a", "New Map") |> render_click() =~
               "New Map"

      assert_patch(index_live, ~p"/maps/new")

      assert index_live
             |> form("#map-form", map: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#map-form", map: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/maps")

      html = render(index_live)
      assert html =~ "Map created successfully"
    end

    test "updates map in listing", %{conn: conn, map: map} do
      {:ok, index_live, _html} = live(conn, ~p"/maps")

      assert index_live |> element("#maps-#{map.id} a", "Edit") |> render_click() =~
               "Edit Map"

      assert_patch(index_live, ~p"/maps/#{map}/edit")

      assert index_live
             |> form("#map-form", map: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#map-form", map: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/maps")

      html = render(index_live)
      assert html =~ "Map updated successfully"
    end

    test "deletes map in listing", %{conn: conn, map: map} do
      {:ok, index_live, _html} = live(conn, ~p"/maps")

      assert index_live |> element("#maps-#{map.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#maps-#{map.id}")
    end
  end

  describe "Show" do
    setup [:create_map]

    test "displays map", %{conn: conn, map: map} do
      {:ok, _show_live, html} = live(conn, ~p"/maps/#{map}")

      assert html =~ "Show Map"
    end

    test "updates map within modal", %{conn: conn, map: map} do
      {:ok, show_live, _html} = live(conn, ~p"/maps/#{map}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Map"

      assert_patch(show_live, ~p"/maps/#{map}/show/edit")

      assert show_live
             |> form("#map-form", map: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#map-form", map: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/maps/#{map}")

      html = render(show_live)
      assert html =~ "Map updated successfully"
    end
  end
end
