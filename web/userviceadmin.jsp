<%@page import="java.sql.ResultSet"%>
<%@page import="database.Dba"%>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Service Administration</title>
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/data-table/bootstrap-table.css">
        <link rel="stylesheet" href="css/data-table/bootstrap-editable.css">
        <link rel="stylesheet" href="css/modal.css">
    </head>

    <script>
        function mod(pid, pNombreServicio, pTipoServicio, pProveedor, pCostoMensual) {
            var modal = document.getElementById("myModal");
            modal.style.display = "block";
            document.getElementById("idh1").value = pid;
            document.getElementById("ids1").value = pNombreServicio;
            document.getElementById("ids2").value = pTipoServicio;
            document.getElementById("ids3").value = pProveedor;
            document.getElementById("ids4").value = pCostoMensual;
        }
    </script>

    <body>
        <jsp:include page="useradmin006.jsp"/>
        <div style="position: absolute; z-index: 10;">
<%
    // Create a new service
    if (request.getParameter("bt_crear") != null) {
        try {
            Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
            db.conectar();

            // Fetch the maximum ID and increment it
            db.query.execute("SELECT MAX(servicioID) FROM servicios");
            ResultSet rs = db.query.getResultSet();
            int newID = 1;  // Default value if table is empty
            if (rs.next()) {
                String maxIDStr = rs.getString(1);
                if (maxIDStr != null && !maxIDStr.isEmpty()) {
                    newID = Integer.parseInt(maxIDStr) + 1;
                }
            }

            int contador = db.query.executeUpdate("INSERT INTO servicios"
                    + "(servicioID, nombreServicio, tipoServicio, proveedor, costomensual) "
                    + "VALUES('" + newID + "',"
                    + "'" + request.getParameter("ti_nombreServicio") + "',"
                    + "'" + request.getParameter("ti_tipoServicio") + "',"
                    + "'" + request.getParameter("ti_proveedor") + "',"
                    + "'" + request.getParameter("ti_costomensual") + "')");
            db.commit();
            db.desconectar();
            if (contador >= 1) {
                out.print("<script>alert('Servicio creado exitosamente');</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

                // Delete a service
                if (request.getParameter("p_editar") != null) {
                    try {
                        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                        db.conectar();
                        int contador = db.query.executeUpdate("DELETE FROM servicios WHERE servicioID='" + request.getParameter("p_servicioID") + "'");
                        db.commit();
                        db.desconectar();
                        if (contador >= 1) {
                            out.print("<script>alert('Servicio borrado exitosamente');</script>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                // Update a service
                if (request.getParameter("bt_modificar") != null) {
                    try {
                        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                        db.conectar();
                        int contador = db.query.executeUpdate("UPDATE servicios SET "
                                + "nombreServicio='" + request.getParameter("ti_nombreServicio") + "', "
                                + "tipoServicio='" + request.getParameter("ti_tipoServicio") + "', "
                                + "proveedor='" + request.getParameter("ti_proveedor") + "', "
                                + "costomensual='" + request.getParameter("ti_costomensual") + "' "
                                + "WHERE servicioID='" + request.getParameter("ti_servicioID") + "'");
                        db.commit();
                        db.desconectar();
                        if (contador >= 1) {
                            out.print("<script>alert('Servicio modificado exitosamente');</script>");
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
                    <form name="fM1" action="userviceadmin.jsp" method="POST">
                        <input type="hidden" id="idh1" name="ti_servicioID" value="" />
                        <table border="1">
                            <tr>
                                <td><center><h4>Modificar Servicio</h4></center></td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0">
                                        <tbody>
                                            <tr>
                                                <td>Nombre del Servicio</td>
                                                <td><input id="ids1" type="text" name="ti_nombreServicio" value="" /></td>
                                                <td>Tipo de Servicio</td>
                                                <td><input id="ids2" type="text" name="ti_tipoServicio" value="" /></td>
                                            </tr>
                                            <tr>
                                                <td>Proveedor</td>
                                                <td><input id="ids3" type="text" name="ti_proveedor" value="" /></td>
                                                <td>Costo Mensual</td>
                                                <td><input id="ids4" type="number" name="ti_costomensual" value="" /></td>
                                            </tr>
                                        </tbody>
                                    </table>                    
                                    <input type="submit" value="Modificar Servicio" name="bt_modificar" /><br>                      
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
                                        <Center><h1>ADMINISTRAR SERVICIOS</h1></center>
                                    </div>
                                </div>

                                <!-- Table for displaying services -->
                                <table id="table" data-toggle="table" data-pagination="true" data-search="true" data-show-columns="true" data-show-pagination-switch="true" data-show-refresh="true" data-key-events="true" data-show-toggle="true" data-resizable="true" data-cookie="true"
                                       data-cookie-id-table="saveId" data-show-export="true" data-click-to-select="true" data-toolbar="#toolbar">
                                    <thead>
                                        <tr>
                                            <th data-field="servicioID">Servicio ID</th>
                                            <th data-field="nombreServicio" data-editable="false">Nombre del Servicio</th>
                                            <th data-field="tipoServicio" data-editable="false">Tipo de Servicio</th> 
                                            <th data-field="proveedor" data-editable="false">Proveedor</th>
                                            <th data-field="costomensual" data-editable="false">Costo Mensual</th>
                                            <th data-field="operaciones" data-editable="false">Operaciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            try {
                                                Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                                                db.conectar();
                                                ResultSet rs = db.query.executeQuery("SELECT * FROM servicios");

                                                while (rs.next()) {
                                                    int servicioID = rs.getInt("servicioID");
                                                    String nombreServicio = rs.getString("nombreServicio");
                                                    String tipoServicio = rs.getString("tipoServicio");
                                                    String proveedor = rs.getString("proveedor");
                                                    int costomensual = rs.getInt("costomensual");
                                        %>
                                        <tr>
                                            <td><%= servicioID %></td>
                                            <td><%= nombreServicio %></td>
                                            <td><%= tipoServicio %></td>
                                            <td><%= proveedor %></td>
                                            <td><%= costomensual %></td>
                                            <td>
                                                <input type="button" value="Eliminar" onclick="window.location = 'userviceadmin.jsp?p_servicioID=<%=servicioID%>&p_editar=1'" />
                                                <input type="button" value="Modificar" onclick="mod('<%=servicioID%>', '<%=nombreServicio%>', '<%=tipoServicio%>', '<%=proveedor%>', '<%=costomensual%>')" />
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

                                <form name="f1" action="userviceadmin.jsp" method="POST">
                                    <div style="position: absolute; z-index: 10;">
                                        <table border="1" width="50"  style="position:absolute;left:50px;top:20px">
                                            <tr>
                                                <td><center><h4>Nuevo Servicio</h4></center></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" width="5">
                                                        <tbody>
                                                            <tr>
                                                                
                                                                <td>Nombre del Servicio</td>
                                                                <td><input type="text" name="ti_nombreServicio" value="" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td>Tipo de Servicio</td>
                                                                <td><input type="text" name="ti_tipoServicio" value="" /></td>
                                                                <td>Proveedor</td>
                                                                <td><input type="text" name="ti_proveedor" value="" /></td>
                                                                <td>Costo Mensual</td>
                                                                <td><input type="number" name="ti_costomensual" value="" /></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <input type="submit" value="Crear Servicio" name="bt_crear" /><br>
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