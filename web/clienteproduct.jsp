<%@page import="java.sql.ResultSet"%>
<%@page import="database.Dba"%>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Product Payment</title>
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/data-table/bootstrap-table.css">
        <link rel="stylesheet" href="css/data-table/bootstrap-editable.css">
        <link rel="stylesheet" href="css/modal.css">
        <style>
            #wb_Shape9 {
                transform: rotate(0deg);
                transform-origin: 50% 50%;
            }
            #Shape9 {
                border-width: 0;
                vertical-align: top;
            }
            #wb_Shape9 {
                margin: 0;
                -webkit-animation: vanish-in 1000ms linear 0ms 1 alternate both;
                animation: vanish-in 1000ms linear 0ms 1 alternate both;
            }
        </style>
    </head>
    <body>
        <jsp:include page="clientepage.jsp"/>
        <div style="position: absolute; z-index: 20;">
            <%
                String userID = (String) session.getAttribute("s_userID");
                String username = (String) session.getAttribute("s_user");
                double userFunds = 0.0;

                try {
                    Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                    db.conectar();
                    db.query.execute("SELECT saldobilletera FROM usuarios WHERE ID='" + userID + "'");
                    ResultSet fundsResultSet = db.query.getResultSet();
                    if (fundsResultSet.next()) {
                        userFunds = fundsResultSet.getDouble("saldobilletera");
                    }
                    db.desconectar();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>

            <%
                if (request.getParameter("payProducts") != null) {
                    double totalCost = 0.0;
                    for (String productID : request.getParameterValues("selectedProduct")) {
                        int quantity = Integer.parseInt(request.getParameter("quantity_" + productID));
                        double productPrice = 0.0;

                        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                        db.conectar();
                        ResultSet rs = db.query.executeQuery("SELECT precio FROM producto WHERE id='" + productID + "'");
                        if (rs.next()) {
                            productPrice = rs.getDouble("precio");
                        }
                        totalCost += productPrice * quantity;
                        rs.close();
                        db.desconectar();
                    }

                    if (userFunds < totalCost) {
                        out.print("<script>alert('Insufficient funds.');</script>");
                    } else {
                        userFunds -= totalCost;
                        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                        db.conectar();
                        int update = db.query.executeUpdate("UPDATE usuarios SET saldobilletera = " + userFunds + " WHERE ID='" + userID + "'");

                        // Add the transaction record after deducting the user's funds
                        String txnInsertQuery = "INSERT INTO txns (tipotxn, origenusuario, destinousuario, cantidadtxn) VALUES ('pagoproducto', '" + username + "', 'pago', " + totalCost + ")";
                        db.query.executeUpdate(txnInsertQuery);

                        db.desconectar();
                        if (update > 0) {
                            out.print("<script>alert('Pago de productos exitoso.');</script>");
                        } else {
                            out.print("<script>alert('El pago de productos fallo.');</script>");
                        }
                    }
                }
            %>
            <div style="position: absolute; left: -450px; top: -100px; background-color: #009999; padding: 10px; border-style: solid; z-index: 30;">
                <strong>USUARIO:</strong> <%= username%><br>
                <strong>ID:</strong> <%= userID%><br>
                <strong>FONDOS:</strong> <%= userFunds%> LPS
            </div>
        </div>

        <div class="data-table-area mg-tb-15" style="margin-top: 100px;  background-color: #009999; border-style: solid; z-index: 10;">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                        <div class="sparkline13-list">
                            <div class="sparkline13-hd">
                                <div class="main-sparkline13-hd">
                                    <Center><h1>PRODUCTOS</h1></center>
                                </div>
                            </div>
                            <form action="" method="post">
                                <table id="table-products" data-toggle="table" style="z-index: 15;">
                                    <thead>
                                        <tr>
                                            <th>Select</th>
                                            <th data-field="ID_producto">ID Producto</th>
                                            <th data-field="nombre_producto">Nombre Producto</th>
                                            <th data-field="precio_producto">Precio</th>
                                            <th>Quantity</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                                            db.conectar();
                                            ResultSet rs = db.query.executeQuery("SELECT * FROM producto");

                                            while (rs.next()) {
                                                int productID = rs.getInt("id");
                                                String productName = rs.getString("nombre_producto");
                                                double productPrice = rs.getDouble("precio");
                                        %>
                                        <tr>
                                            <td><input type="checkbox" name="selectedProduct" value="<%= productID%>"></td>
                                            <td><%= productID%></td>
                                            <td><%= productName%></td>
                                            <td><%= productPrice%></td>
                                            <td><input type="number" name="quantity_<%= productID%>" min="1" value="1"></td>
                                        </tr>
                                        <%
                                            }
                                            rs.close();
                                            db.desconectar();
                                        %>
                                    </tbody>
                                </table>
                                <input type="submit" value="PAGAR PRODUCTOS" name="payProducts">
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>



        <!-- ... (rest of the scripts) ... -->


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
            var closeModalButton = document.getElementById("closeModal");
            var modal = document.getElementById("myModal");
            closeModalButton.addEventListener("click", function () {
                modal.style.display = "none";
            });
        </script>

    </body>
</html>