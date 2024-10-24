<%@page import="java.sql.ResultSet"%>
<%@page import="database.Dba"%>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Product Administration</title>
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/data-table/bootstrap-table.css">
        <link rel="stylesheet" href="css/data-table/bootstrap-editable.css">
        <link rel="stylesheet" href="css/modal.css">
        
        
    </head>

    <script>
        function mod(pid, pNombreProducto, pDescripcion, pEstadoProducto, pPrecio, pExistencia, pFechaVencimiento) {
            var modal = document.getElementById("myModal");
            modal.style.display = "block";
            document.getElementById("idh1").value = pid;
            document.getElementById("ids1").value = pNombreProducto;
            document.getElementById("ids2").value = pDescripcion;
            document.getElementById("ids3").value = pEstadoProducto;
            document.getElementById("ids4").value = pPrecio;
            document.getElementById("ids5").value = pExistencia;
            document.getElementById("ids6").value = pFechaVencimiento;
        }
    </script>

    <body>
        <jsp:include page="useradmin006.jsp"/>
        <div style="position: absolute; z-index: 10;">
            <%
                // Create a new product
                if (request.getParameter("bt_crear") != null) {
                    try {
                        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                        db.conectar();
                        out.print("<script>console.log('Database connected');</script>");

                        // Fetch the maximum ID and increment it
                        db.query.execute("SELECT MAX(Id) FROM producto");
                        ResultSet rs = db.query.getResultSet();
                        int newID = 1;  // Default value if table is empty
                        if (rs.next()) {
                            String maxIDStr = rs.getString(1);
                            if (maxIDStr != null && !maxIDStr.isEmpty()) {
                                newID = Integer.parseInt(maxIDStr) + 1;
                            }
                        }

int contador = db.query.executeUpdate("INSERT INTO producto"
        + "(nombre_producto, descripcion, estado_producto, precio, existencia, fecha_vencimiento) "
        + "VALUES("
        + "'" + request.getParameter("ti_nombreProducto") + "',"
        + "'" + request.getParameter("ti_descripcion") + "',"
        + "'" + request.getParameter("ti_estadoProducto") + "',"
        + "'" + request.getParameter("ti_precio") + "',"
        + "'" + request.getParameter("ti_existencia") + "',"
        + "'" + request.getParameter("ti_fechaVencimiento") + "')");

                        if (contador == 1) {
                            out.print("<script>alert('Producto creado exitosamente');</script>");
                        } else {
                            out.print("<script>alert('Fallo la creación del producto');</script>");
                        }
                        db.commit();
                        db.desconectar();
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.print("<script>alert('Ocurrió un error: " + e.getMessage() + "');</script>");
                    }
                }

                // Delete a product
                if (request.getParameter("p_editar") != null) {
                    try {
                        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                        db.conectar();
                        int contador = db.query.executeUpdate("DELETE FROM producto WHERE Id='" + request.getParameter("p_id") + "'");
                        db.commit();
                        db.desconectar();
                        if (contador >= 1) {
                            out.print("<script>alert('Producto eliminado exitosamente');</script>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                // Update a product
                if (request.getParameter("bt_modificar") != null) {
                    try {
                        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                        db.conectar();
                        int contador = db.query.executeUpdate("UPDATE producto SET "
                                + "nombre_producto='" + request.getParameter("ti_nombreProducto") + "', "
                                + "descripcion='" + request.getParameter("ti_descripcion") + "', "
                                + "estado_producto='" + request.getParameter("ti_estadoProducto") + "', "
                                + "precio='" + request.getParameter("ti_precio") + "', "
                                + "existencia='" + request.getParameter("ti_existencia") + "', "
                                + "fecha_vencimiento='" + request.getParameter("ti_fechaVencimiento") + "' "
                                + "WHERE Id='" + request.getParameter("ti_id") + "'");
                        db.commit();
                        db.desconectar();
                        if (contador >= 1) {
                            out.print("<script>alert('Producto actualizado exitosamente');</script>");
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
                    <form name="fM1" action="uproductadmin.jsp" method="POST">
                        <input type="hidden" id="idh1" name="ti_id" value="" />
                        <table border="1">
                            <tr>
                                <td><center><h4>Modificar Producto</h4></center></td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0">
                                        <tbody>
                                            <tr>
                                                <td>Nombre Producto</td>
                                                <td><input id="ids1" type="text" name="ti_nombreProducto" value="" /></td>
                                                <td>Descripción</td>
                                                <td><input id="ids2" type="text" name="ti_descripcion" value="" /></td>
                                            </tr>
                                            <tr>
                                                <td>Estado Producto</td>
                                                <td><input id="ids3" type="text" name="ti_estadoProducto" value="" /></td>
                                                <td>Precio</td>
                                                <td><input id="ids4" type="text" name="ti_precio" value="" /></td>
                                            </tr>
                                            <tr>
                                                <td>Existencia</td>
                                                <td><input id="ids5" type="text" name="ti_existencia" value="" /></td>
                                                <td>Fecha Vencimiento</td>
                                                <td><input id="ids6" type="text" name="ti_fechaVencimiento" value="" /></td>
                                            </tr>
                                        </tbody>
                                    </table>                    
                                    <input type="submit" value="Modificar Producto" name="bt_modificar" /><br>                      
                                </td>
                            </tr>
                        </table>
                    </form>    
                    </p>
                </div>
            </div>

            <!-- Main content -->
            <div class="data-table-area mg-tb-15" style="margin-top: -120px;" >
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="sparkline13-list">
                                <div class="sparkline13-hd">
                                    <div class="main-sparkline13-hd">
                                        <Center><h1>ADMINISTRAR PRODUCTOS</h1></center>
                                    </div>
                                </div>

                                <!-- Table for displaying products -->
                                <table id="table" data-toggle="table" data-pagination="true" data-search="true" data-show-columns="true" data-show-pagination-switch="true" data-show-refresh="true" data-key-events="true" data-show-toggle="true" data-resizable="true" data-cookie="true"
                                       data-cookie-id-table="saveId" data-show-export="true" data-click-to-select="true" data-toolbar="#toolbar">
                                    <thead>
                                        <tr>
                                            <th data-field="Id">ID</th>
                                            <th data-field="nombre_producto" data-editable="false">Nombre Producto</th>
                                            <th data-field="descripcion" data-editable="false">Descripción</th> 
                                            <th data-field="estado_producto" data-editable="false">Estado Producto</th>
                                            <th data-field="precio" data-editable="false">Precio</th>
                                            <th data-field="existencia" data-editable="false">Existencia</th>
                                            <th data-field="fecha_vencimiento" data-editable="false">Fecha Vencimiento</th>
                                            <th data-field="operaciones" data-editable="false">Operaciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            try {
                                                Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                                                db.conectar();
                                                ResultSet rs = db.query.executeQuery("SELECT * FROM producto");

                                                while (rs.next()) {
                                                    int id = rs.getInt("Id");
                                                    String nombreProducto = rs.getString("nombre_producto");
                                                    String descripcion = rs.getString("descripcion");
                                                    String estadoProducto = rs.getString("estado_producto");
                                                    String precio = rs.getString("precio");
                                                    String existencia = rs.getString("existencia");
                                                    String fechaVencimiento = rs.getString("fecha_vencimiento");
                                        %>
                                        <tr>
                                            <td><%= id%></td>
                                            <td><%= nombreProducto%></td>
                                            <td><%= descripcion%></td>
                                            <td><%= estadoProducto%></td>
                                            <td><%= precio %></td>
                                            <td><%= existencia %></td>
                                            <td><%= fechaVencimiento %></td>
                                            <td>
                                                <input type="button" value="Eliminar" onclick="window.location = 'uproductadmin.jsp?p_id=<%=id%>&p_editar=1'" />
                                                <input type="button" value="Modificar" onclick="mod('<%=id%>', '<%=nombreProducto%>', '<%=descripcion%>', '<%=estadoProducto%>', '<%=precio%>', '<%=existencia%>', '<%=fechaVencimiento%>')" />
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

                                <form name="f1" action="uproductadmin.jsp" method="POST">
                                    <div style="position: absolute; z-index: 10;">
                                        <table border="1" width="50" style="position:absolute;left:150px;top:20px">
                                            <tr>
                                                <td><center><h4>Nuevo Producto</h4></center></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" width="50" >
                                                        <tbody>
                                                            <tr>
                                                                <td>Nombre Producto</td>
                                                                <td><input type="text" name="ti_nombreProducto" value="" /></td>
                                                                <td>Descripción</td>
                                                                <td><input type="text" name="ti_descripcion" value="" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td>Estado Producto</td>
                                                                <td><input type="text" name="ti_estadoProducto" value="" /></td>
                                                                <td>Precio</td>
                                                                <td><input type="text" name="ti_precio" value="" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td>Existencia</td>
                                                                <td><input type="text" name="ti_existencia" value="" /></td>
                                                                <td>Fecha Vencimiento</td>
                                                                <td><input type="text" name="ti_fechaVencimiento" value="" /></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <input type="submit" value="Crear Producto" name="bt_crear" /><br>
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
