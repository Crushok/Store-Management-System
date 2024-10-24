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



        function transferFunds(sourceUserID, destinationUserID) {
            var modal = document.getElementById("myModal");
            modal.style.display = "block";
            document.getElementById("sourceUserID").value = sourceUserID;
            document.getElementById("destinationUserID").value = destinationUserID;
        }
    <!-- function para transferir fondos--> 

</script>

   <body>
    <jsp:include page="pulperiapage.jsp"/>
    <div style="position: absolute; z-index: 10;">
        <%
            // Compruebe si el formulario ha sido enviado
            if (request.getParameter("bt_transfer") != null) {
                try {
                    Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                    db.conectar();

                    // Obtenga los ID de usuario de origen y destino y el monto a transferir desde el formulario
                    String sourceUserID = request.getParameter("sourceUserID");
                    String destinationUserID = request.getParameter("destinationUserID");
                    String amountToTransfer = request.getParameter("amountToTransfer");

                    // Validar que el usuario fuente tenga fondos suficientes
                    db.query.execute("SELECT saldobilletera FROM usuarios WHERE ID='" + sourceUserID + "'");
                    ResultSet sourceUserResultSet = db.query.getResultSet();
                    double sourceUserBalance = 0.0;
                    if (sourceUserResultSet.next()) {
                        sourceUserBalance = sourceUserResultSet.getDouble("saldobilletera");
                    }

                    // Compruebe si el usuario fuente tiene fondos suficientes
                    double transferAmount = Double.parseDouble(amountToTransfer);
                    if (sourceUserBalance < transferAmount) {
                        out.print("<script>alert('Fondos insuficientes en la cuenta del usuario de origen.');</script>");
                    } else {
                        // Continúe con la lógica de transferencia de fondos aquí
                        // Deducir el monto de la transferencia del saldo del usuario de origen
                        int updateSourceUser = db.query.executeUpdate("UPDATE usuarios SET saldobilletera = saldobilletera - " + transferAmount + " WHERE ID='" + sourceUserID + "'");
                        // Actualizar el saldo del usuario de destino agregando el monto de la transferencia
                        int updateDestinationUser = db.query.executeUpdate("UPDATE usuarios SET saldobilletera = saldobilletera + " + transferAmount + " WHERE ID='" + destinationUserID + "'");
                        db.commit();
                        db.desconectar();

                        if (updateSourceUser >= 1 && updateDestinationUser >= 1) {
                            out.print("<script>alert('Fondos transferidos exitosamente.');</script>");
                        } else {
                            out.print("<script>alert('La transferencia de fondos falló.');</script>");
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.print("<script>alert('Se produjo un error al procesar la transferencia de fondos..');</script>");
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
                            <Center><h1>TRANSFERENCIAS</h1></center>
                        </div>
                    </div>

                    <table id="table-funds" data-toggle="table" data-pagination="true" data-search="true" data-show-columns="true" data-show-pagination-switch="true" data-show-refresh="true" data-key-events="true" data-show-toggle="true" data-resizable="true" data-cookie="true"
                           data-cookie-id-table="saveId" data-show-export="true" data-click-to-select="true" data-toolbar="#toolbar">
                        <thead>
                            <tr>
                                <th data-field="userID">User ID</th>
                                <th data-field="usuario">Usuario</th>
                                <th data-field="nombre">Nombre</th>
                                <th data-field="apellido">Apellido</th>
                                <th data-field="rol">Rol</th> <!-- Add the "rol" column header -->
                                <th data-field="funds">Fondos</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% try {
                                Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                                db.conectar();
                                ResultSet rs = db.query.executeQuery("SELECT ID, usuario, nombre, apellido, rol, saldobilletera FROM usuarios WHERE rol='cliente' OR rol='pulperia'");

                                while (rs.next()) {
                                    int id = rs.getInt("ID");
                                    String usuario = rs.getString("usuario");
                                    String nombre = rs.getString("nombre");
                                    String apellido = rs.getString("apellido");
                                    String rol = rs.getString("rol");
                                    String funds = rs.getString("saldobilletera");
                            %>
                            <tr>
                                <td><%= id %></td>
                                <td><%= usuario %></td>
                                <td><%= nombre %></td>
                                <td><%= apellido %></td>
                                <td><%= rol %></td> <!-- Display the "rol" data -->
                                <td><%= funds %></td>
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





                            <form name="f1" action="pulptransfer.jsp" method="POST">
                                <div style="position: absolute; z-index: 10;">
                                    <table border="1" width="500" style="position:absolute;left:-50px;top:10px">
                                        <tr>
                                            <td><center><h4>Transferir fondos</h4></center></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table border="0" width="5">
                                                    <tbody>
                                                        <tr>
                                                            <td>ID Usuario</td>
                                                            <td>
                                                                <select name="sourceUserID">
                                                                    <!-- Options will be generated from the database -->
                                                                    <%
                                                                        try {
                                                                            Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                                                                            db.conectar();
                                                                            ResultSet rs = db.query.executeQuery("SELECT ID FROM usuarios WHERE rol='cliente' OR rol='pulperia'");

                                                                            while (rs.next()) {
                                                                                int id = rs.getInt("ID");
                                                                    %>
                                                                    <option value="<%= id%>"><%= id%></option>
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
                                                            <td>ID usuario destino</td>
                                                            <td><input type="text" name="destinationUserID" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Cantidad a transferir</td>
                                                            <td><input type="text" name="amountToTransfer" /></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <input type="submit" value="Transfer Funds" name="bt_transfer" /><br>
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
