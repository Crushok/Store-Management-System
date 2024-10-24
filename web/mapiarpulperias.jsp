<%@page import="java.sql.ResultSet"%>
<%@page import="database.Dba"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Manejo de Mapas</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <!-- Leaflet.js CSS and JavaScript -->
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>

        <script type="text/javascript">
            function mostrar_amigos() {
                // Initial map location: Latitude and Longitude
                var ubicacion = [14.6203, -87.644]; // LatLng for Leaflet is [latitude, longitude]

                // Create the map and set its initial location and zoom level
                var map = L.map('mapa').setView(ubicacion, 7);

                // Add OpenStreetMap tiles
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                }).addTo(map);

                <% 
                String ami = "", lat = "", lon = "", info = "";
                try {
                    Dba db = new Dba(application.getRealPath("") + "daw.mdb");
                    db.conectar();

                    // Query the database to select only records with rol='pulperia'
                    db.query.execute("select usuario, latitud, longitud, nombre from usuarios where rol='pulperia'");
                    ResultSet rs = db.query.getResultSet();

                    while (rs.next()) {
                        ami = rs.getString(1);
                        lat = rs.getString(2);
                        lon = rs.getString(3);
                        info = rs.getString(4);
                %>
                        // Add a marker for each "pulperia" (friend) from the database
                        var marker = L.marker([<%=lat%>, <%=lon%>]).addTo(map);
                        marker.bindPopup('<%=info%>').openPopup();
                <% 
                    }
                    db.desconectar();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                %>
            }
        </script>       
    </head>
    <center>
        <body>
            <div id="mapa" style="width: 900px; height: 500px; border: 5px groove #006600;"></div>
            <input type="button" value="Mostrar amigos" onclick="mostrar_amigos()"/>
        </body>
    </center>
</html>
