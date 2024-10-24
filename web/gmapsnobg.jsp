<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mapa Pulperias</title>
        
        <!-- Leaflet.js CSS and JavaScript -->
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
        
        <script type="text/javascript">
            function mostrar_mapa(centinela) {
                // Initial map location: Latitude and Longitude
                var ubicacion = [14.6203, -87.644]; // LatLng for Leaflet is [latitude, longitude]
                
                // Create the map and set its initial location and zoom level
                var map = L.map('mapa').setView(ubicacion, 7);
                
                // Add OpenStreetMap tiles
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                }).addTo(map);

                // Add a popup that displays LatLng on map click
                var popup = L.popup().setLatLng(ubicacion).setContent('Haga click sobre el mapa <br> para ver Latitud y Longitud!').openOn(map);

                // Map click event to display LatLng
                map.on('click', function (e) {
                    popup
                        .setLatLng(e.latlng)
                        .setContent(e.latlng.toString())
                        .openOn(map);
                    
                    // Update latitude and longitude input fields
                    var latLngArray = e.latlng.toString().replace("LatLng(", "").replace(")", "").split(", ");
                    document.getElementById("id_lat").value = latLngArray[0];
                    document.getElementById("id_long").value = latLngArray[1];
                });

                // If centinela is 1, add a marker
                if (centinela == 1) {
                    var marker = L.marker([14.104173, -87.186145]).addTo(map);
                    marker.bindPopup('Elaborado Por: Osman Mejía<br/>Clase: DAW<br/>Tipo: Ejemplo').openPopup();
                }
            }
            
            function mostrar_triangulo() {
                // Initial map location for the triangle
                var ubicacion = [24.886436490187712, -70.2685546875];

                // Create the map and set the initial location and zoom level
                var map = L.map('mapa').setView(ubicacion, 5);

                // Add OpenStreetMap tiles
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                }).addTo(map);

                // Define the coordinates for the Bermuda Triangle
                var triangleCoords = [
                    [25.774252, -80.190262],
                    [18.466465, -66.118292],
                    [32.321384, -64.75737],
                    [25.774252, -80.190262]
                ];

                // Create a polygon for the Bermuda Triangle and add it to the map
                var bermudaTriangle = L.polygon(triangleCoords, {
                    color: 'red',
                    fillOpacity: 0.35
                }).addTo(map);

                // Bind a popup to the triangle
                bermudaTriangle.bindPopup("Bermuda Triangle");
            }
        </script>
    </head>
    <body onload="mostrar_mapa(0)">
        <div style="position: relative; z-index: 10;">
            <!-- Map container with better positioning -->
            <div id="mapa" style="width: 100%; height: 400px; border: 5px groove #006600;"></div>
        </div>
    </body>
</html>
