<%@page import="java.sql.ResultSet"%>
<%@page import="database.Dba"%>
<!doctype html>
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Comercio Administration</title>
    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/data-table/bootstrap-table.css">
    <link rel="stylesheet" href="css/data-table/bootstrap-editable.css">
    <link rel="stylesheet" href="css/modal.css">
</head>

<script>
    function mod(pid, pNombreComercio, pUbicacion, pTipoComercio, pContacto, pPrecioServicio, pDescripcionServicio) {
        var modal = document.getElementById("myModal");
        modal.style.display = "block";
        document.getElementById("idh1").value = pid;
        document.getElementById("ids1").value = pNombreComercio;
        document.getElementById("ids2").value = pUbicacion;
        document.getElementById("ids3").value = pTipoComercio;
        document.getElementById("ids4").value = pContacto;
        document.getElementById("ids5").value = pPrecioServicio;
        document.getElementById("ids6").value = pDescripcionServicio;
    }
</script>

<body>
    <jsp:include page="useradmin006.jsp"/>
    <div style="position: absolute; z-index: 10;">
        <%
            // Create a new comercio
            if (request.getParameter("bt_crear") != null) {
                try {
                    Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                    db.conectar();
                    out.print("<script>console.log('Database connected');</script>");

                    // Fetch the maximum ID and increment it
                    db.query.execute("SELECT MAX(idcomercio) FROM comercios");
                    ResultSet rs = db.query.getResultSet();
                    int newID = 1;  // Default value if table is empty
                    if (rs.next()) {
                        String maxIDStr = rs.getString(1);
                        if (maxIDStr != null && !maxIDStr.isEmpty()) {
                            newID = Integer.parseInt(maxIDStr) + 1;
                        }
                    }

                    int contador = db.query.executeUpdate("INSERT INTO comercios"
                            + "(idcomercio, nombreComercio, ubicacion, tipoComercio, contacto, precioServicio, descripcionServicio) "
                            + "VALUES('" + newID + "',"
                            + "'" + request.getParameter("ti_nombreComercio") + "',"
                            + "'" + request.getParameter("ti_ubicacion") + "',"
                            + "'" + request.getParameter("ti_tipoComercio") + "',"
                            + "'" + request.getParameter("ti_contacto") + "',"
                            + "'" + request.getParameter("ti_precioServicio") + "',"
                            + "'" + request.getParameter("ti_descripcionServicio") + "')");

                    if (contador == 1) {
                        out.print("<script>alert('Comercio creado exitosamente');</script>");
                    } else {
                        out.print("<script>alert('Fallo la creación del comercio');</script>");
                    }
                    db.commit();
                    db.desconectar();
                } catch (Exception e) {
                    e.printStackTrace();
                    out.print("<script>alert('Ocurrió un error: " + e.getMessage() + "');</script>");
                }
            }

            // Delete a comercio
            if (request.getParameter("p_editar") != null) {
                try {
                    Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                    db.conectar();
                    int contador = db.query.executeUpdate("DELETE FROM comercios WHERE idcomercio='" + request.getParameter("p_id") + "'");
                    db.commit();
                    db.desconectar();
                    if (contador >= 1) {
                        out.print("<script>alert('Comercio eliminado exitosamente');</script>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            // Update a comercio
            if (request.getParameter("bt_modificar") != null) {
                try {
                    Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                    db.conectar();
                    int contador = db.query.executeUpdate("UPDATE comercios SET "
                            + "nombreComercio='" + request.getParameter("ti_nombreComercio") + "', "
                            + "ubicacion='" + request.getParameter("ti_ubicacion") + "', "
                            + "tipoComercio='" + request.getParameter("ti_tipoComercio") + "', "
                            + "contacto='" + request.getParameter("ti_contacto") + "', "
                            + "precioServicio='" + request.getParameter("ti_precioServicio") + "', "
                            + "descripcionServicio='" + request.getParameter("ti_descripcionServicio") + "' "
                            + "WHERE idcomercio='" + request.getParameter("ti_id") + "'");
                    db.commit();
                    db.desconectar();
                    if (contador >= 1) {
                        out.print("<script>alert('Comercio actualizado exitosamente');</script>");
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
                <form name="fM1" action="ucomerciosadmin.jsp" method="POST">
                    <input type="hidden" id="idh1" name="ti_id" value="" />
                    <table border="1">
                        <tr>
                            <td><center><h4>Modificar Comercio</h4></center></td>
                        </tr>
                        <tr>
                            <td>
                                <table border="0">
                                    <tbody>
                                        <tr>
                                            <td>Nombre Comercio</td>
                                            <td><input id="ids1" type="text" name="ti_nombreComercio" value="" /></td>
                                            <td>Ubicación</td>
                                            <td><input id="ids2" type="text" name="ti_ubicacion" value="" /></td>
                                        </tr>
                                        <tr>
                                            <td>Tipo Comercio</td>
                                            <td><input id="ids3" type="text" name="ti_tipoComercio" value="" /></td>
                                            <td>Contacto</td>
                                            <td><input id="ids4" type="text" name="ti_contacto" value="" /></td>
                                        </tr>
                                        <tr>
                                            <td>Precio Servicio</td>
                                            <td><input id="ids5" type="text" name="ti_precioServicio" value="" /></td>
                                            <td>Descripción Servicio</td>
                                            <td><input id="ids6" type="text" name="ti_descripcionServicio" value="" /></td>
                                        </tr>
                                    </tbody>
                                </table>                    
                                <input type="submit" value="Modificar Comercio" name="bt_modificar" /><br>                      
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
                                    <Center><h1>ADMINISTRAR COMERCIOS</h1></center>
                                </div>
                            </div>

                            <!-- Table for displaying comercios -->
                            <table id="table" data-toggle="table" data-pagination="true" data-search="true" data-show-columns="true" data-show-pagination-switch="true" data-show-refresh="true" data-key-events="true" data-show-toggle="true" data-resizable="true" data-cookie="true"
                                   data-cookie-id-table="saveId" data-show-export="true" data-click-to-select="true" data-toolbar="#toolbar" style="width: 50%;" >
                                <thead>
                                    <tr>
                                        <th data-field="idcomercio">ID</th>
                                        <th data-field="nombreComercio" data-editable="false">Nombre Comercio</th>
                                        <th data-field="ubicacion" data-editable="false">Ubicación</th> 
                                        <th data-field="tipoComercio" data-editable="false">Tipo Comercio</th>
                                        <th data-field="contacto" data-editable="false">Contacto</th>
                                        <th data-field="precioServicio" data-editable="false">Precio Servicio</th>
                                        <th data-field="descripcionServicio" data-editable="false">Descripción Servicio</th>
                                        <th data-field="operaciones" data-editable="false">Operaciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try {
                                            Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                                            db.conectar();
                                            ResultSet rs = db.query.executeQuery("SELECT * FROM comercios");

                                            while (rs.next()) {
                                                int id = rs.getInt("idcomercio");
                                                String nombreComercio = rs.getString("nombreComercio");
                                                String ubicacion = rs.getString("ubicacion");
                                                String tipoComercio = rs.getString("tipoComercio");
                                                String contacto = rs.getString("contacto");
                                                String precioServicio = rs.getString("precioServicio");
                                                String descripcionServicio = rs.getString("descripcionServicio");
                                    %>
                                    <tr>
                                        <td><%= id%></td>
                                        <td><%= nombreComercio%></td>
                                        <td><%= ubicacion%></td>
                                        <td><%= tipoComercio%></td>
                                        <td><%= contacto %></td>
                                        <td><%= precioServicio %></td>
                                        <td><%= descripcionServicio %></td>
                                        <td>
                                            <input type="button" value="Eliminar" onclick="window.location = 'ucomerciosadmin.jsp?p_id=<%=id%>&p_editar=1'" />
                                            <input type="button" value="Modificar" onclick="mod('<%=id%>', '<%=nombreComercio%>', '<%=ubicacion%>', '<%=tipoComercio%>', '<%=contacto%>', '<%=precioServicio%>', '<%=descripcionServicio%>')" />
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

                            <form name="f1" action="ucomerciosadmin.jsp" method="POST">
                                <div style="position: absolute; z-index: 10;">
                                    <table border="1" width="50" style="position:absolute;left:120px;top:20px">
                                        <tr>
                                            <td><center><h4>Nuevo Comercio</h4></center></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table border="0" width="50">
                                                    <tbody>
                                                        <tr>
                                                            <td>Nombre Comercio</td>
                                                            <td><input type="text" name="ti_nombreComercio" value="" /></td>
                                                            <td>Ubicación</td>
                                                            <td><input type="text" name="ti_ubicacion" value="" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Tipo Comercio</td>
                                                            <td><input type="text" name="ti_tipoComercio" value="" /></td>
                                                            <td>Contacto</td>
                                                            <td><input type="text" name="ti_contacto" value="" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Precio Servicio</td>
                                                            <td><input type="text" name="ti_precioServicio" value="" /></td>
                                                            <td>Descripción Servicio</td>
                                                            <td><input type="text" name="ti_descripcionServicio" value="" /></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <input type="submit" value="Crear Comercio" name="bt_crear" /><br>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </form>
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
</body>
</html>