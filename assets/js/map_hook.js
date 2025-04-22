export default {
  mounted() {
    console.group('MapHook Initialization');
    console.log('MapHook mounted, el:', this.el);
    console.log('LiveView hook:', this.liveSocket);
    console.log('Window siteData:', window.siteData);
    
    try {
      // Verify LiveView connection
      if (!this.liveSocket) {
        console.error('LiveSocket not available');
        return;
      }
      console.log('LiveSocket connected:', this.liveSocket);
      console.log('LiveSocket connection state:', this.liveSocket.isConnected());
      
      // Initialize the map
      this.map = L.map('map').setView([20, 0], 2);
      console.log('Map initialized');
      
      // Verify event binding
      this.handleEvent = this.handleEvent.bind(this);
      console.log('Event handler bound');
      
      // Add tile layer
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
      }).addTo(this.map);

      // Verify event binding
      this.handleEvent = this.handleEvent.bind(this);
      console.log('Event handler bound');
      
      // Verify LiveView connection
      if (!this.liveSocket) {
        console.error('LiveSocket not available');
        return;
      }
      console.log('LiveSocket connected');
      
      // Test event pushing
      console.log('Testing event push...');
      this.pushEvent('test-event', {test: 'data'}, (reply) => {
        console.log('Test event reply:', reply);
      });

      // Store markers in an array
      this.markers = [];
      this.updateMarkers();
      
      // Listen for refresh events
      this.handleEvent("refresh-map", () => {
        console.log('Received refresh-map event');
        this.updateMarkers();
      });

    } catch (error) {
      console.error('MapHook initialization error:', error);
    }
    console.groupEnd();
  },

  updateMarkers() {
    // Clear existing markers
    this.markers.forEach(marker => marker.remove());
    this.markers = [];

    // Add new markers
    window.siteData.forEach(site => {
      const marker = L.marker([site.latitude, site.longitude])
        .addTo(this.map)
        .on('click', () => {
          console.log('Marker clicked, site ID:', site.id);
          console.log('Pushing marker-clicked event to LiveView');
          this.pushEvent('marker-clicked', { id: site.id }, (reply, ref) => {
            console.log('Event reply:', reply);
            console.log('Event ref:', ref);
            if (reply.status === 'ok') {
              const popupContent = `
                <div class="leaflet-popup-content-wrapper">
                  <div class="leaflet-popup-content" style="width: 152px;">
                    <div class="p-2 max-w-xs">
                      <h3 class="text-lg font-bold text-gray-800">${site.name}</h3>
                      <p class="text-sm text-gray-600"><span class="font-semibold">Latitude:</span> ${site.latitude}</p>
                      <p class="text-sm text-gray-600"><span class="font-semibold">Longitude:</span> ${site.longitude}</p>
                    </div>
                  </div>
                </div>
              `;
              marker.bindPopup(popupContent).openPopup();
            }
          });
        });
      this.markers.push(marker);
    });
  }
}
