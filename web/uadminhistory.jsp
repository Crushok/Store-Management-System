<%@page import="java.sql.ResultSet"%>
<%@page import="database.Dba"%>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Transaction Records</title>
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/data-table/bootstrap-table.css">
        <link rel="stylesheet" href="css/data-table/bootstrap-editable.css">
        <link rel="stylesheet" href="css/modal.css">
        
        <style>
  /* Add this style to make the table borders thicker */
  #table-txns {
    border-collapse: collapse;
    border: 2px solid #000; /* You can adjust the border thickness and color as needed */
  }

  #table-txns th, #table-txns td {
    border: 2px solid #000; /* You can adjust the border thickness and color as needed */
    padding: 8px; /* Optional: Add padding to cells for better appearance */
  }
</style>
    </head>

    <body>
        
        <jsp:include page="useradmin006.jsp"/>
        <div style="position: absolute; z-index: 10;">
        <!-- Main content -->
        <div class="data-table-area mg-tb-15" style="margin-top: -120px;  border-style: solid; background-color: #009999">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                        <div class="sparkline13-list">
                            <div class="sparkline13-hd">
                                <div class="main-sparkline13-hd">
                                    <Center><h1>Historial de Transacciones</h1></center>
                                </div>
                            </div>

                            <table id="table-txns" data-toggle="table" data-pagination="true" data-search="true" data-show-columns="true" data-show-pagination-switch="true" data-show-refresh="true" data-key-events="true" data-show-toggle="true" data-resizable="true" data-cookie="true"
                                   data-cookie-id-table="saveId" data-show-export="true" data-click-to-select="true" data-toolbar="#toolbar" >
                                <thead>
                                    <tr>
                                        <th data-field="transactionID">ID Transaccion</th>
                                        <th data-field="tipotxn">Tipo Transaccion</th>
                                        <th data-field="origenusuario">Usuario Origen</th>
                                        <th data-field="destinousuario">Usuario Destino</th>
                                        <th data-field="cantidadtxn">Cantidad</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    try {
                                        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                                        db.conectar();
                                        ResultSet rs = db.query.executeQuery("SELECT * FROM txns");

                                        while (rs.next()) {
                                            int txnID = rs.getInt("ID");
                                            String tipoTxn = rs.getString("tipotxn");
                                            String origenUsuario = rs.getString("origenusuario");
                                            String destinoUsuario = rs.getString("destinousuario");
                                            double cantidadTxn = rs.getDouble("cantidadtxn");
                                    %>
                                    <tr>
                                        <td><%= txnID%></td>
                                        <td><%= tipoTxn%></td>
                                        <td><%= origenUsuario%></td>
                                        <td><%= destinoUsuario%></td>
                                        <td><%= cantidadTxn%></td>
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

    </body>
</html>