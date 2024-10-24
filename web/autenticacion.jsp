<%@page import="java.sql.*"%>
<%@page import="database.*"%>

<%
    try {
        // Initialize database connection
        Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
        db.conectar();
        db.query.execute("SELECT ID, usuario, clave, rol FROM usuarios");
        ResultSet rs = db.query.getResultSet();

        // Initialize variables
        String centinela = "n";
        String userRole = "";
        String userID = ""; // Initialize user ID

        // Get user input
        String inputUser = request.getParameter("ti_usuario");
        String inputPassword = request.getParameter("ti_password");

        // Validate user credentials
        while (rs.next()) {
            if (inputUser.equals(rs.getString("usuario")) && inputPassword.equals(rs.getString("clave"))) {
                centinela = "s";
                userRole = rs.getString("rol");
                userID = rs.getString("ID"); // Retrieve the user ID
            }
        }

        // Check if user exists
        if ("s".equals(centinela)) {
            // Store session variables
            session.setAttribute("s_user", inputUser);
            session.setAttribute("s_pass", inputPassword);
            session.setAttribute("s_userID", userID); // Store the user ID in the session

            // Redirect based on user role
            String targetPage = "index.jsp";
            if ("admin".equals(userRole)) {
                targetPage = "useradmin006.jsp";
            } else if ("pulperia".equals(userRole)) {
                targetPage = "pulperiapage.jsp";
            } else if ("cliente".equals(userRole)) {
                targetPage = "clientepage.jsp";
            }
            request.getRequestDispatcher(targetPage).forward(request, response);
        } else {
            out.print("<script>alert('El usuario no existe')</script>");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }

        // Close database connection
        db.desconectar();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>