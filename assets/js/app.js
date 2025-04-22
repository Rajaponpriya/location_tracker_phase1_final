import "phoenix_html";
import "../css/app.css";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let Hooks = {};

Hooks.MapHook = {
  mounted() {
    // Initialize Leaflet map
    const map = L.map(this.el).setView([0, 0], 2); // Default view (world)
    let markers = L.layerGroup().addTo(map); // Create a layer group for markers

    // Add OpenStreetMap tiles
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(map);

    // Function to update map with sites
    const updateMap = (sites) => {
      // Clear existing markers
      markers.clearLayers();

      // Add new markers
      sites.forEach(site => {
        const insertedAt = site.inserted_at
          ? new Date(site.inserted_at).toLocaleString() || "N/A"
          : "N/A";
        const updatedAt = site.updated_at
          ? new Date(site.updated_at).toLocaleString() || "N/A"
          : "N/A";

        const popupContent = `
          <div class="p-2 max-w-xs">
            <h3 class="text-lg font-bold text-gray-800">${site.name}</h3>
            <p class="text-sm text-gray-600"><span class="font-semibold">Latitude:</span> ${site.latitude}</p>
            <p class="text-sm text-gray-600"><span class="font-semibold">Longitude:</span> ${site.longitude}</p>
  
          </div>
        `;

        L.marker([site.latitude, site.longitude])
          .addTo(markers)
          .bindPopup(popupContent);
      });

      // Fit map to bounds of all markers
      if (sites.length > 0) {
        const bounds = L.latLngBounds(sites.map(site => [site.latitude, site.longitude]));
        map.fitBounds(bounds, { padding: [50, 50] });
      }
    };

    // Initial map load
    const sites = JSON.parse(this.el.dataset.sites);
    updateMap(sites);

    // Listen for refresh-map event
    this.handleEvent("refresh-map", () => {
      // Fetch updated sites from the server or data attribute
      const updatedSites = JSON.parse(this.el.dataset.sites);
      updateMap(updatedSites);
    });
  }
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", _info => topbar.show(300));
window.addEventListener("phx:page-loading-stop", _info => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;


// Add toast display logic
window.addEventListener("phx:show-toast", (event) => {
  const { message, type } = event.detail;

  // Create toast element
  const toast = document.createElement("div");
  toast.className = `fixed top-4 right-4 p-4 rounded shadow-lg text-white ${
    type === "success" ? "bg-green-500" : "bg-red-500"
  }`;
  toast.textContent = message;

  // Append to body
  document.body.appendChild(toast);

  // Auto-remove after 3 seconds
  setTimeout(() => {
    toast.remove();
  }, 3000);
});