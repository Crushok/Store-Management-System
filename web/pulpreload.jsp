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
    </script>

    <body>
        <jsp:include page="pulperiapage.jsp"/>
        <div style="position: absolute; z-index: 10;">
            <%
// Actualizar saldo de la billetera del cliente
if (request.getParameter("bt_modificar") != null) {
    try {
        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
        db.conectar();

        // Obtener el ID del usuario y el saldo a recargar desde el formulario
        String userID = request.getParameter("ti_id");
        String nuevoSaldo = request.getParameter("ti_saldobilletera");

        // Verificar que el saldo a recargar sea un número válido
        double nuevoSaldoValue = Double.parseDouble(nuevoSaldo);
        if (nuevoSaldoValue < 0) {
            out.print("<script>alert('El nuevo saldo debe ser un número positivo.');</script>");
        } else {
            // Actualizar el saldo de la billetera del cliente sumándolo al saldo existente
            int contador = db.query.executeUpdate("UPDATE usuarios SET "
                    + "saldobilletera=saldobilletera + " + nuevoSaldoValue
                    + " WHERE ID='" + userID + "'");
            db.commit();
            db.desconectar();
            if (contador >= 1) {
                out.print("<script>alert('Saldo de billetera modificado exitosamente.');</script>");
            } else {
                out.print("<script>alert('No se pudo modificar el saldo de la billetera.');</script>");
            }
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
                                                <td><input id="ids4" type="text" name="ti_rol" value="" /></td>
                                            </tr>
                                            <tr>
                                                <td>Saldo Billetera</td> <!-- New line -->
                                                <td><input id="ids6" type="text" name="ti_saldobilletera" value="" /></td> <!-- New line -->
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
                            <Center><h1>RECARGAS</h1></center>
                        </div>
                    </div>

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
                                <th data-field="saldobilletera" data-editable="false">Saldo Billetera</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                                    db.conectar();
                                    ResultSet rs = db.query.executeQuery("SELECT ID, usuario, clave, nombre, apellido, rol, saldobilletera FROM usuarios WHERE rol='cliente'");

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
                                <td><%= saldobilletera%></td>
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
                        
                        
                        
                        
<form name="f1" action="pulpreload.jsp" method="POST">
    <div style="position: absolute; z-index: 10;">
        <table border="1" width="400" style="position:absolute;left:50px;top:20px">
            <tr>
                <td><center><h4>RECARGAR</h4></center></td>
            </tr>
            <tr>
                <td>
                    <table border="0" width="5">
                        <tbody>
                            <tr>
                                <td>ID del Usuario</td>
                                <td>
                                    <select name="ti_id">
                                        <!-- Aquí se generan las opciones desde la base de datos -->
                                        <%
                                            try {
                                                Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                                                db.conectar();
                                                ResultSet rs = db.query.executeQuery("SELECT ID FROM usuarios WHERE rol='cliente'");

                                                while (rs.next()) {
                                                    int id = rs.getInt("ID");
                                        %>
                                        <option value="<%= id %>"><%= id %></option>
                                        <%
                                                }
                                                rs.close();
                                                db.desconectar();
                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Nuevo Saldo Billetera</td>
                                <td><input type="text" name="ti_saldobilletera" value="" /></td>
                            </tr>
                        </tbody>
                    </table>
                    <input type="submit" value="RECARGAR" name="bt_modificar" /><br>
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
    
    
</script> 

</body>
</html>
