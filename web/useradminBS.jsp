<%@page import="java.sql.ResultSet"%>
<%@page import="database.Dba"%>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>User Administration</title>
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/data-table/bootstrap-table.css">
        <link rel="stylesheet" href="css/data-table/bootstrap-editable.css">
        <link rel="stylesheet" href="css/modal.css">

        <Style>
            #wb_Shape9
            {
                transform: rotate(0deg);
                transform-origin: 50% 50%;
            }
            #Shape9
            {
                border-width: 0;
                vertical-align: top;
            }
            #wb_Shape9
            {
                margin: 0;
                -webkit-animation: vanish-in 1000ms linear 0ms 1 alternate both;
                animation: vanish-in 1000ms linear 0ms 1 alternate both;
            }
        </style>

    </head>

    <script>
        function mod(pid, pUsuario, pClave, pNombre, pRol) {
            var modal = document.getElementById("myModal");
            modal.style.display = "block";
            document.getElementById("idh1").value = pid;
            document.getElementById("ids1").value = pUsuario;
            document.getElementById("ids2").value = pClave;
            document.getElementById("ids3").value = pNombre;
            document.getElementById("ids4").value = pRol;
        }



        function checkRole() {
            var roleSelect = document.getElementById("roleSelect");
            var selectedRole = roleSelect.options[roleSelect.selectedIndex].value;
            var locationFields = document.getElementById("locationFields");

            if (selectedRole === "pulperia") {
                locationFields.style.display = "table-row";
            } else {
                locationFields.style.display = "none";
            }
        }


        function checkRole() {
            var roleSelect = document.getElementById("roleSelect");
            var selectedRole = roleSelect.options[roleSelect.selectedIndex].value;
            var locationFields = document.getElementById("locationFields");
            var mapContent = document.getElementById("mapContent");

            if (selectedRole === "pulperia") {
                locationFields.style.display = "table-row";
                mapContent.style.display = "block";
            } else {
                locationFields.style.display = "none";
                mapContent.style.display = "none";
            }
        }



</script>


    <body>
        <jsp:include page="useradmin006.jsp"/>

        <div style="position: absolute; z-index: 10;">
            <%
                if (request.getParameter("bt_crear") != null) {
                    try {
                        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                        db.conectar();
                        out.print("<script>console.log('Database connected');</script>");

                        // Check if the username already exists
                        String inputUsername = request.getParameter("ti_usuario");
                        db.query.execute("SELECT COUNT(*) FROM usuarios WHERE usuario='" + inputUsername + "'");
                        ResultSet countRs = db.query.getResultSet();
                        int existingUserCount = 0;
                        if (countRs.next()) {
                            existingUserCount = countRs.getInt(1);
                        }

                        if (existingUserCount > 0) {
                            out.print("<script>alert('El usuario ya existe');</script>");
                        } else {
                            // Fetch the maximum ID and increment it
                            db.query.execute("SELECT MAX(ID) FROM usuarios");
                            ResultSet rs = db.query.getResultSet();
                            int newID = 1;  // Default value if the table is empty
                            if (rs.next()) {
                                String maxIDStr = rs.getString(1);
                                if (maxIDStr != null && !maxIDStr.isEmpty()) {
                                    newID = Integer.parseInt(maxIDStr) + 1;
                                }
                            }

                            String role = request.getParameter("ti_rol");
                            String sql;

                            if ("pulperia".equals(role)) {
                                sql = "INSERT INTO usuarios"
                                        + "(ID, usuario, clave, nombre, rol, saldobilletera, longitud, latitud) "
                                        + "VALUES('" + newID + "',"
                                        + "'" + inputUsername + "',"
                                        + "'" + request.getParameter("ti_clave") + "',"
                                        + "'" + request.getParameter("ti_nombre") + "',"
                                        + "'" + role + "', 0," // Set saldobilletera to 0
                                        + "'" + request.getParameter("ti_latitud") + "',"
                                        + "'" + request.getParameter("ti_longitud") + "')";
                            } else {
                                sql = "INSERT INTO usuarios"
                                        + "(ID, usuario, clave, nombre, rol, saldobilletera) "
                                        + "VALUES('" + newID + "',"
                                        + "'" + inputUsername + "',"
                                        + "'" + request.getParameter("ti_clave") + "',"
                                        + "'" + request.getParameter("ti_nombre") + "',"
                                        + "'" + role + "', 0)";  // Set saldobilletera to 0
                            }

                            int contador = db.query.executeUpdate(sql);

                            if (contador == 1) {
                                out.print("<script>alert('Usuario creado exitosamente');</script>");
                            } else {
                                out.print("<script>alert('Fallo la creación del usuario');</script>");
                            }
                            db.commit();
                        }

                        db.desconectar();
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.print("<script>alert('Ocurrió un error: " + e.getMessage() + "');</script>");
                    }
                }

                // Delete a user
                if (request.getParameter("p_editar") != null) {
                    try {
                        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                        db.conectar();
                        int contador = db.query.executeUpdate("DELETE FROM usuarios WHERE ID='" + request.getParameter("p_id") + "'");
                        db.commit();
                        db.desconectar();
                        if (contador >= 1) {
                            out.print("<script>alert('Usuario Eliminado Exitosamente');</script>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                // Modificar usuario
                if (request.getParameter("bt_modificar") != null) {
                    try {
                        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                        db.conectar();

                        String updateSQL = "UPDATE usuarios SET "
                                + "usuario='" + request.getParameter("ti_usuario") + "', "
                                + "clave='" + request.getParameter("ti_clave") + "', "
                                + "nombre='" + request.getParameter("ti_nombre") + "', "
                                + "apellido='" + request.getParameter("ti_apellido") + "', "
                                + "rol='" + request.getParameter("ti_rol") + "'";

                        // If the role is pulperia, add the latitud and longitud to the update statement
                        if ("pulperia".equals(request.getParameter("ti_rol"))) {
                            updateSQL += ", "
                                    + "latitud='" + request.getParameter("ti_latitud") + "', "
                                    + "longitud='" + request.getParameter("ti_longitud") + "'";
                        }

                        updateSQL += " WHERE ID='" + request.getParameter("ti_id") + "'";

                        int contador = db.query.executeUpdate(updateSQL);
                        db.commit();
                        db.desconectar();
                        if (contador >= 1) {
                            out.print("<script>alert('Usuario Modificado Exitosamente');</script>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            %>



            <!-- Modal for editing -->
            <div id="myModal" class="modal">  
                <div class="modal-content">
                    <span class="close" id="closeModal">x</span>

                    <p> 
<form name="fM1" action="useradminBS.jsp" method="POST">
    <input type="hidden" id="idh1" name="ti_id" value="" />
    <table border="1">
        <tr>
            <td><center><h4>Modificar Usuario</h4></center></td>
        </tr>
        <tr>
            <td>
                <table border="0">
                    <tbody>
                        <tr>
                            <td>Usuario</td>
                            <td><input id="ids1" type="text" name="ti_usuario" value="" /></td>
                            <td>Clave</td>
                            <td><input id="ids2" type="password" name="ti_clave" value="" /></td>
                        </tr>
                        <tr>
                            <td>Nombre</td>
                            <td><input id="ids3" type="text" name="ti_nombre" value="" /></td>
                            <td>Apellido</td>
                            <td><input id="ids5" type="text" name="ti_apellido" value="" /></td>
                            <td>Rol</td>
                            <td><input id="ids4" type="text" name="ti_rol" value="" readonly /></td>
                        </tr>
                        <tr>
                            <td>Saldo Billetera</td>
                            <td><input id="ids6" type="text" name="ti_saldobilletera" value="" /></td>
                        </tr>
                    </tbody>
                </table>                    
                <input type="submit" value="Modificar Usuario" name="bt_modificar" /><br>                      
            </td>
        </tr>
    </table>
</form>



                    </p>
                </div>
            </div>

            <!-- Main content -->
            <div class="data-table-area mg-tb-15" style="margin-top: -120px;">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="sparkline13-list">
                                <div class="sparkline13-hd">
                                    <div class="main-sparkline13-hd">
                                        <Center><h1>ADMINISTRAR USUARIOS</h1></center>
                                    </div>
                                </div>

                                <!-- Table for displaying users -->
                                <!-- Table for displaying users -->
                                <table id="table" data-toggle="table" data-pagination="true" data-search="true" data-show-columns="true" data-show-pagination-switch="true" data-show-refresh="true" data-key-events="true" data-show-toggle="true" data-resizable="true" data-cookie="true"
                                       data-cookie-id-table="saveId" data-show-export="true" data-click-to-select="true" data-toolbar="#toolbar">
                                    <thead>
                                        <tr>
                                            <th data-field="id">ID</th>
                                            <th data-field="usuario" data-editable="false">Usuario</th>
                                            <th data-field="clave" data-editable="false">Clave</th> 
                                            <th data-field="nombre" data-editable="false">Nombre</th>
                                            <th data-field="apellido" data-editable="false">Apellido</th>
                                            <th data-field="rol" data-editable="false">Rol</th>
                                            <th data-field="saldobilletera" data-editable="false">Saldo Billetera</th> <!-- New line -->
                                            <th data-field="operaciones" data-editable="false">Operaciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            try {
                                                Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                                                db.conectar();
                                                ResultSet rs = db.query.executeQuery("SELECT ID, usuario, clave, nombre, apellido, rol, saldobilletera FROM usuarios");

                                                while (rs.next()) {
                                                    int id = rs.getInt("ID");
                                                    String usuario = rs.getString("usuario");
                                                    String clave = rs.getString("clave");
                                                    String nombre = rs.getString("nombre");
                                                    String apellido = rs.getString("apellido");
                                                    String rol = rs.getString("rol");
                                                    String saldobilletera = rs.getString("saldobilletera");
                                        %>
                                        <tr>
                                            <td><%= id%></td>
                                            <td><%= usuario%></td>
                                            <td><%= clave%></td>
                                            <td><%= nombre%></td>
                                            <td><%= apellido%></td>
                                            <td><%= rol%></td>
                                            <td><%= saldobilletera%></td> <!-- New line -->
                                            <td>
                                                <input type="button" value="Eliminar" onclick="window.location = 'useradminBS.jsp?p_id=<%= id%>&p_editar=1'" />
                                                <input type="button" value="Modificar" onclick="mod('<%= id%>', '<%= usuario%>', '<%= clave%>', '<%= nombre%>', '<%= rol%>')" />
                                            </td>
                                        </tr>
                                        <%
                                                }
                                                rs.close();
                                                db.desconectar();
                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            }
                                        %>
                                    </tbody>
                                </table>



                                <form name="f1" action="useradminBS.jsp" method="POST">
                                    <div style="position: absolute; z-index: 10;">
                                        <table border="1" width="50" style="position:absolute;left:-15px;top:20px">
                                            <tr>
                                                <td><center><h4>Nuevo Usuario</h4></center></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" width="5">
                                                        <tbody>
                                                            <tr>
                                                                <td>Usuario</td>
                                                                <td><input type="text" name="ti_usuario" value="" /></td>
                                                                <td>Clave</td>
                                                                <td><input type="password" name="ti_clave" value="" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td>Nombre</td>
                                                                <td><input type="text" name="ti_nombre" value="" /></td>
                                                                <td>Apellido</td>
                                                                <td><input type="text" name="ti_apellido" value="" /></td>
                                                                <td>Rol</td>
                                                                <td>
                                                                    <select id="roleSelect" name="ti_rol" onchange="checkRole()">
                                                                        <option value="admin">Admin</option>
                                                                        <option value="cliente">Cliente</option>
                                                                        <option value="pulperia">Pulperia</option>
                                                                    </select>
                                                                </td>
                                                            </tr>
                                                            <!-- Location fields -->
                                                            <tr id="locationFields" style="display:none;">
                                                                <td>latitud</td>
                                                                <td><input type="text" name="ti_longitud" value="" id="id_lat" /></td>
                                                                <td>longitud</td>
                                                                <td><input type="text" name="ti_latitud" value="" id="id_long" /></td>
                                                                
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <input type="submit" value="Crear Usuario" name="bt_crear" /><br>
                                                </td>
                                            </tr>
                                        </table>
                                        <!-- Placeholder for the map content -->
                                        <div id="mapContent" style="display:none;">
                                            <jsp:include page="gmapsnobg.jsp"/>

                                        </div>
                                </form>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!-- Scripts -->
    <script src="js/vendor/jquery-1.11.3.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/data-table/bootstrap-table.js"></script>
    <script src="js/modal.js"></script>
    <script src="js/data-table/tableExport.js"></script>
    <script src="js/data-table/data-table-active.js"></script>
    <script src="js/data-table/bootstrap-table-editable.js"></script>
    <script src="js/data-table/bootstrap-editable.js"></script>
    <script src="js/data-table/bootstrap-table-resizable.js"></script>
    <script src="js/data-table/colResizable-1.5.source.js"></script>
    <script src="js/data-table/bootstrap-table-export.js"></script>
    <script src="js/tab.js"></script>
    

    <!-- close modal modificar 
    <script>
    // Get a reference to the close button element
    var closeModalButton = document.getElementById("closeModal");
    
    // Get a reference to the modal element
    var modal = document.getElementById("myModal");
    
    // Add a click event listener to the close button
    closeModalButton.addEventListener("click", function() {
        modal.style.display = "none"; // Hide the modal
    });
    
    --> 

    <script>
                                                                        // Get the "x" button element by its ID
                                                                        var closeModalButton = document.getElementById("closeModal");

                                                                        // Get the modal element by its ID
                                                                        var modal = document.getElementById("myModal");

                                                                        // Add a click event listener to the "x" button
                                                                        closeModalButton.addEventListener("click", function () {
                                                                            // Hide the modal when the "x" button is clicked
                                                                            modal.style.display = "none";
                                                                        });
    </script>
</script>    
</body>
</html>
