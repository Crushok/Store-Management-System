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
    <jsp:include page="clientepage.jsp"/>
    <div style="position: absolute; z-index: 10;">
   <%
        // Check if the form has been submitted
        if (request.getParameter("bt_transfer") != null) {
            try {
                Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                db.conectar();

                String sourceUserID = request.getParameter("sourceUserID");
                String destinationUserID = request.getParameter("destinationUserID");
                String amountToTransfer = request.getParameter("amountToTransfer");

                // Fetch the usernames based on the provided IDs
                String sourceUsername = "";
                String destinationUsername = "";

                db.query.execute("SELECT usuario FROM usuarios WHERE ID='" + sourceUserID + "'");
                ResultSet sourceUserResultSet = db.query.getResultSet();
                if (sourceUserResultSet.next()) {
                    sourceUsername = sourceUserResultSet.getString("usuario");
                }

                db.query.execute("SELECT usuario FROM usuarios WHERE ID='" + destinationUserID + "'");
                ResultSet destinationUserResultSet = db.query.getResultSet();
                if (destinationUserResultSet.next()) {
                    destinationUsername = destinationUserResultSet.getString("usuario");
                }

                // Fetch the source user's balance
                db.query.execute("SELECT saldobilletera FROM usuarios WHERE ID='" + sourceUserID + "'");
                sourceUserResultSet = db.query.getResultSet();
                double sourceUserBalance = 0.0;
                if (sourceUserResultSet.next()) {
                    sourceUserBalance = sourceUserResultSet.getDouble("saldobilletera");
                }

                double transferAmount = Double.parseDouble(amountToTransfer);
                if (sourceUserBalance < transferAmount) {
                    out.print("<script>alert('Fondos insuficientes en la cuenta del usuario de origen.');</script>");
                } else {
                    // Deduct from source user
                    int updateSourceUser = db.query.executeUpdate("UPDATE usuarios SET saldobilletera = saldobilletera - " + transferAmount + " WHERE ID='" + sourceUserID + "'");
                    // Add to destination user
                    int updateDestinationUser = db.query.executeUpdate("UPDATE usuarios SET saldobilletera = saldobilletera + " + transferAmount + " WHERE ID='" + destinationUserID + "'");
                    
                    // Insert transaction record into txns database
                    String insertTxnQuery = "INSERT INTO txns (ID, tipotxn, origenusuario, destinousuario, cantidadtxn) VALUES ('" + sourceUserID + "', 'transferencia', '" + sourceUsername + "', '" + destinationUsername + "', '" + amountToTransfer + "')";
                    db.query.executeUpdate(insertTxnQuery);

                    db.commit();

                    if (updateSourceUser >= 1 && updateDestinationUser >= 1) {
                        out.print("<script>alert('Fondos transferidos exitosamente.');</script>");
                    } else {
                        out.print("<script>alert('La transferencia de fondos falló.');</script>");
                    }
                }
                db.desconectar();
            } catch (Exception e) {
                e.printStackTrace();
                out.print("<script>alert('Se produjo un error al procesar la transferencia de fondos..');</script>");
            }
        }
    %>


        <!-- Main content -->
        <div class="data-table-area mg-tb-15" style="margin-top: -120px;  background-color: #009999; border-style: solid">
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
                                   data-cookie-id-table="saveId" data-show-export="true" data-click-to-select="true" data-toolbar="#toolbar" >
                                <thead>
                                    <tr>
                                        <th data-field="userID">User ID</th>
                                        <th data-field="usuario">Usuario</th>
                                        <th data-field="nombre">Nombre</th>
                                        <th data-field="apellido">Apellido</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% try {
                                            Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                                            db.conectar();
                                            ResultSet rs = db.query.executeQuery("SELECT ID, usuario, nombre, apellido, saldobilletera FROM usuarios WHERE rol='cliente'");

                                            while (rs.next()) {
                                                int id = rs.getInt("ID");
                                                String usuario = rs.getString("usuario");
                                                String nombre = rs.getString("nombre");
                                                String apellido = rs.getString("apellido");
                                    %>
                                    <tr>
                                        <td><%= id%></td>
                                        <td><%= usuario%></td>
                                        <td><%= nombre%></td>
                                        <td><%= apellido%></td>
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
                        </div>
                    </div>
                </div>
            </div>
        </div>


<div style="position: absolute; z-index: 10;">
    <%
        // Fetch the user's fund information based on their session or login details
        String userID = (String) session.getAttribute("s_userID");
        String username = (String) session.getAttribute("s_user"); // Retrieve the username
        double userFunds = 0.0; // Initialize userFunds variable

        try {
            Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
            db.conectar();

            // Retrieve the user's funds based on their user ID
            db.query.execute("SELECT saldobilletera FROM usuarios WHERE ID='" + userID + "'");
            ResultSet fundsResultSet = db.query.getResultSet();

            if (fundsResultSet.next()) {
                userFunds = fundsResultSet.getDouble("saldobilletera");
            }

            // Close the database connection
            db.desconectar();
        } catch (Exception e) {
            e.printStackTrace();
        }

    // Display the user's funds and username in the same box
    %>
    <div style="position: absolute; left: -200px; top: -300px; background-color: #009999; padding: 10px; border-style: solid">
        <strong>USUARIO:</strong> <%= username %><br>
        <strong>ID:</strong> <%= userID %><br>
        <strong>FONDOS:</strong> <%= userFunds %> LPS
    </div>
</div>





<form name="f1" action="clientetransfer.jsp" method="POST">
    <div style="position: absolute; z-index: 10;">
        <table border="1" width="500" style="position:absolute;left:-50px;top:50px;  background-color: #009999; border-style: dashed" >
            <tr>
                <td colspan="2"><center><h4>Transferir fondos</h4></center></td>
            </tr>
            <tr>
                <td width="30%">ID Usuario</td>
                <td>
                    <!-- Display the current user's ID here -->
                    <input type="text" name="sourceUserID" value="<%= (String) session.getAttribute("s_userID") %>" readonly />
                </td>
            </tr>
            <tr>
                <td>ID usuario destino</td>
                <td>
                    <select name="destinationUserID">
                        <!-- Options will be generated from the database, excluding the current user's ID -->
                        <%
                            try {
                                Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                                db.conectar();
                                
                                // Retrieve the current user's ID
                                String currentUserID = (String) session.getAttribute("s_userID");
                                
                                // Query to retrieve user IDs excluding the current user's ID
                                String query = "SELECT ID FROM usuarios WHERE rol='cliente' AND ID != '" + currentUserID + "'";
                                
                                ResultSet rs = db.query.executeQuery(query);

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
                <td>Cantidad a transferir</td>
                <td><input type="text" name="amountToTransfer" /></td>
            </tr>
            <tr>
                <!-- Move the button input inside the table -->
                <td colspan="2"><input type="submit" value="Transferir fondos" name="bt_transfer" /></td>
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
