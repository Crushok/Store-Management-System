<%@page import="java.sql.ResultSet"%>
<%@page import="database.Dba"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mapa Pulperias</title>

        <!-- Leaflet.js CSS and JavaScript -->
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>

        <style>
            #mapa {
                width: 1000px;
                height: 720px;
                border: 5px groove #006600;
            }
        </style>

        <script type="text/javascript">
            var map;

            // Initialize the map only once
            function init_map() {
                var ubicacion = [14.6203, -87.644]; // Default map center (Lat, Lon)

                // Create the map only if it doesn't already exist
                if (!map) {
                    map = L.map('mapa').setView(ubicacion, 7);
                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                    }).addTo(map);
                }
            }

            // Clear all existing markers from the map
            function clear_map() {
                if (map) {
                    map.eachLayer(function (layer) {
                        if (layer instanceof L.Marker) {
                            map.removeLayer(layer);
                        }
                    });
                }
            }

            // Show amigos (friends) from the database
            function mostrar_amigos() {
                clear_map(); // Clear existing markers

                // Output for debugging
                console.log("Fetching amigos from the database...");

                <% 
                // Initialize a JavaScript array to store data
                StringBuilder amigosData = new StringBuilder("[");
                try {
                    Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                    db.conectar();

                    // Query the database to select only records with rol='pulperia'
                    db.query.execute("select usuario, latitud, longitud, nombre from usuarios where rol='pulperia'");
                    ResultSet rs = db.query.getResultSet();

                    boolean first = true;
                    while (rs.next()) {
                        // Print data for debugging
                        out.println("<!-- Usuario: " + rs.getString(1) + ", Lat: " + rs.getString(2) + ", Lon: " + rs.getString(3) + ", Info: " + rs.getString(4) + " -->");

                        if (!first) {
                            amigosData.append(",");
                        }
                        amigosData.append("{");
                        amigosData.append("\"usuario\": \"").append(rs.getString(1)).append("\",");
                        amigosData.append("\"lat\": ").append(rs.getString(2)).append(",");
                        amigosData.append("\"lon\": ").append(rs.getString(3)).append(",");
                        amigosData.append("\"info\": \"").append(rs.getString(4)).append("\"");
                        amigosData.append("}");
                        first = false;
                    }
                    db.desconectar();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                amigosData.append("]");
                %>

                // Parse the amigosData JSON-like string from the JSP to JavaScript
                var amigos = <%= amigosData.toString() %>;

                // Log the data for debugging
                console.log("Amigos data:", amigos);

                // Check if amigos array is empty
                if (amigos.length === 0) {
                    console.warn("No amigos found in the database.");
                    return;
                }

                // Loop through the data and create markers for each amigo
                amigos.forEach(function (amigo) {
                    // Check if lat/lon values are valid numbers
                    if (!isNaN(amigo.lat) && !isNaN(amigo.lon)) {
                        var marker = L.marker([amigo.lat, amigo.lon]).addTo(map);
                        marker.bindPopup(amigo.info);
                    } else {
                        console.error("Invalid Lat/Lon for amigo:", amigo);
                    }
                });
            }
        </script>
    </head>
    <body onload="init_map()">
        <jsp:include page="useradmin006.jsp"/>

        <div style="position: relative; z-index: 10;">
            <!-- Map container -->
            <div id="mapa"></div>

            <!-- Button to clear the map -->
            <img src="images/img0019.png" alt="Limpiar ubicación" style="position: absolute; top: 725px; left: 100px; width: 120px; cursor: pointer;" onclick="clear_map()">

            <!-- Button to show "pulperias" (amigos) from the database -->
            <img src="images/img0018.png" alt="Pulperias" style="position: absolute; top: 725px; left: -50px; width: 120px; cursor: pointer;" onclick="mostrar_amigos()">
        </div>
    </body>
</html>
