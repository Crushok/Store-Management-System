<%@page import="database.Dba"%>
<%@page import="java.sql.ResultSet"%>
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
                width: 700px;
                height: 500px;
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

            // Show pulperias (stores) from the database
            function mostrar_amigos() {
                clear_map(); // Clear existing markers

                <% 
                // Initialize a JSON-like array for storing pulperias data
                StringBuilder amigosData = new StringBuilder("[");
                boolean first = true;

                try {
                    Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                    db.conectar();

                    // Query to get both the current user (if they're a store) and other pulperias
                    db.query.execute("select usuario, latitud, longitud, nombre from usuarios where rol='pulperia' or ID='" + (String) session.getAttribute("s_userID") + "'");
                    ResultSet rs = db.query.getResultSet();

                    while (rs.next()) {
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

                // Convert the data into a usable JavaScript array
                var amigos = <%= amigosData.toString() %>;

                // Loop through each amigo (store) and create a marker on the map
                amigos.forEach(function (amigo) {
                    var marker = L.marker([amigo.lat, amigo.lon]).addTo(map);
                    marker.bindPopup(amigo.info);
                });
            }
        </script>
    </head>
    <body onload="init_map()">
        <jsp:include page="pulperiapage.jsp"/>

        <div style="position: relative; z-index: 10;">
            <!-- Map container -->
            <div id="mapa"></div>

            <!-- Button to clear the map -->
            <img src="images/img0019.png" alt="Limpiar ubicación" style="position: absolute; top: 500px; left: 500px; width: 120px; cursor: pointer;" onclick="clear_map()">

            <!-- Button to show "pulperias" from the database -->
            <img src="images/img0002.png" alt="Pulperias" style="position: absolute; top: 500px; left: 400px; width: 120px; cursor: pointer;" onclick="mostrar_amigos()">

            <!-- Begin Update Location Form -->
            <form action="pulpmap.jsp" method="post">
                <div id="locationFields" style="display:none;">
                    <input type="text" name="ti_latitud" value="" id="id_lat" style="position: absolute; top: -200px; left: 350px"/>
                    <input type="text" name="ti_longitud" value="" id="id_long" style="position: absolute; top: -175px; left: 350px" />
                    <input type="submit" name="bt_modificar" value="Modificar ubicación" style="position: absolute; top: -150px; left: 350px" />
                </div>
            </form>
            <!-- End Update Location Form -->

        </div>
    </body>
</html>
