defmodule LocationTrackerWeb.MapLive.Index do
  use LocationTrackerWeb, :live_view

  alias LocationTracker.Sites
  alias LocationTracker.Sites.Map

  @impl true
  def mount(_params, _session, socket) do
    sites = Sites.list_sites()
    {:ok, assign(socket, sites: sites, changeset: Sites.change_site(%LocationTracker.Sites.Site{}))}
  end

  @impl true
  def handle_info({LocationTrackerWeb.MapLive.SiteFormComponent, {:saved, site}}, socket) do
    sites = [site | socket.assigns.sites]
    {:noreply, assign(socket, sites: sites)}
  end

  @impl true
  def handle_info({LocationTrackerWeb.MapLive.FormComponent, {:saved, map}}, socket) do
    {:noreply, stream_insert(socket, :maps, map)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Map")
    |> assign(:map, Sites.get_map!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Map")
    |> assign(:map, %Map{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Maps")
    |> assign(:map, nil)
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Site Locations")
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    map = Sites.get_map!(id)
    {:ok, _} = Sites.delete_map(map)

    {:noreply, stream_delete(socket, :maps, map)}
  end

  # *** ADDED: Handle marker-clicked event ***
  @impl true
  def handle_event("marker-clicked", %{"id" => id}, socket) do
    site = Sites.get_site!(id)
    {:reply, %{status: "ok", user_name: site.user_name}, socket}
  end
end
