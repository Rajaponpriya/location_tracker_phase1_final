defmodule LocationTrackerWeb.MapLive do
  use LocationTrackerWeb, :live_view
  alias LocationTracker.Sites

  @impl true
  def mount(_params, _session, socket) do
    sites = format_sites(Sites.list_sites())
    {:ok, assign(socket, sites: sites)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-screen flex flex-col">
      <h1 class="text-3xl font-bold text-center my-4">Site Locations</h1>
      <%= if @sites == [] do %>
        <p class="text-center text-gray-600">No sites available</p>
      <% else %>
        <div id="map" class="flex-grow" phx-hook="MapHook" data-sites={Jason.encode!(@sites)}></div>
      <% end %>
    </div>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    """
  end

  @impl true
  def handle_info({LocationTrackerWeb.MapLive.SiteFormComponent, {:saved, site}}, socket) do
    # Update sites list with the new site
    updated_sites = socket.assigns.sites ++ [format_site(site)]
    {:noreply, assign(socket, sites: updated_sites)}
  end

  defp format_site(site) do
    %{
      name: site.name,
      latitude: site.latitude,
      longitude: site.longitude,
      inserted_at: NaiveDateTime.to_iso8601(site.inserted_at),
      updated_at: NaiveDateTime.to_iso8601(site.updated_at)
    }
  end

  defp format_sites(sites) do
    Enum.map(sites, &format_site/1)
  end
end
