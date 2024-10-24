<%@page import="database.Dba"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="javax.mail.*"%>
<%@page import="javax.mail.internet.*"%>
<%@page import="java.util.Properties"%>

<!doctype html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Animated Login Form with Form</title>
    <link rel="stylesheet" href="register.css">

    <script type="text/javascript">
        function registrationSuccess() {
            alert('Registrado exitosamente');
            window.location = 'index.jsp';
        }
    </script>
</head>

<body>
    <section>
        <span></span> <!-- Repeating animated background spans -->

        <%
            boolean registrationSuccessful = false;
            if (request.getParameter("bt_register") != null) {
                try {
                    Dba db = new Dba(application.getRealPath("") + "/daw.mdb");
                    db.conectar();

                    ResultSet rs = db.query.executeQuery("SELECT MAX(ID) FROM usuarios");
                    int newID = 0;
                    if (rs.next()) {
                        newID = rs.getInt(1) + 1;
                    }

                    int counter = db.query.executeUpdate("INSERT INTO usuarios"
                            + "(ID, usuario, clave, nombre, apellido, rol) "
                            + "VALUES(" + newID + ","
                            + "'" + request.getParameter("ti_usuario") + "',"
                            + "'" + request.getParameter("ti_clave") + "',"
                            + "'" + request.getParameter("ti_nombre") + "',"
                            + "'" + request.getParameter("ti_apellido") + "',"
                            + "'cliente')");

                    if (counter == 1) {
                        registrationSuccessful = true;

                        // Send registration confirmation email
                        try {
                            // Retrieve user's email from the input
                            String userEmail = request.getParameter("ti_email");

                            // Define email parameters as final variables
                            final String senderEmail = "neyibbendeck@unitec.edu"; // Your email address
                            final String senderPassword = "Sticky01"; // Your email password
                            String emailSubject = "Registration Confirmation";
                            String emailBody = "Thank you for registering on our website. Your registration was successful.";

                            // Email sending logic
                            Properties props = new Properties();
                            props.put("mail.smtp.host", "smtp.office365.com");
                            props.put("mail.smtp.port", "587");
                            props.put("mail.smtp.auth", "true");
                            props.put("mail.smtp.starttls.enable", "true");
                            props.put("mail.smtp.ssl.protocols", "TLSv1.2");

                            // Create the session with an Authenticator
                            Session mailSession = Session.getInstance(props, new Authenticator() {
                                @Override
                                protected PasswordAuthentication getPasswordAuthentication() {
                                    return new PasswordAuthentication(senderEmail, senderPassword);
                                }
                            });

                            // Create a MimeMessage using the 'mailSession'
                            MimeMessage message = new MimeMessage(mailSession);

                            // Set the recipient (user's email)
                            message.addRecipient(Message.RecipientType.TO, new InternetAddress(userEmail));

                            // Set the email subject and body
                            message.setSubject(emailSubject);
                            message.setText(emailBody);

                            // Send the email
                            Transport.send(message);

                            // Send a confirmation message to the user
                            out.print("<script>alert('Registrado exitosamente. Se ha enviado un correo de confirmación.');</script>");
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                    db.commit();
                    db.desconectar();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            if (registrationSuccessful) {
                out.print("<script>registrationSuccess();</script>");
            }
        %>

        <!-- Sign-in Form -->
        <div class="signin">
            <div class="content">
                <h2 style="color: #00FF00;">Nuevo Usuario</h2>
                <form name="Form1" method="POST" action="register.jsp" enctype="application/x-www-form-urlencoded" id="Form1" class="form">
                    <!-- Add an email input field -->
                    <div class="inputBox">
                        <input type="text" id="Editbox1" name="ti_email" value="" required>
                        <label for="Editbox1" style="color: #00C853;">CORREO ELECTRÓNICO</label>
                    </div>
                    <!-- Rest of the form fields -->
                    <div class="inputBox">
                        <input type="text" id="Editbox1" name="ti_usuario" value="" required>
                        <label for="Editbox1" style="color: #00C853;">USUARIO</label>
                    </div>
                    <div class="inputBox">
                        <input type="password" id="Editbox2" name="ti_clave" value="" required>
                        <label for="Editbox2" style="color: #00C853;">CLAVE</label>
                    </div>
                    <div class="inputBox">
                        <input type="text" id="Editbox3" name="ti_nombre" value="" required>
                        <label for="Editbox3" style="color: #00C853;">NOMBRE</label>
                    </div>
                    <div class="inputBox">
                        <input type="text" id="Editbox3" name="ti_apellido" value="" required>
                        <label for="Editbox4" style="color: #00C853;">APELLIDO</label>
                    </div>
                    <input type="submit" id="Button1" name="bt_register" value="Registrarse" style="background-color: #00C853; color: #000000; font-weight: normal; font-size: 20px; padding: 15px 6px;">
                </form>
            </div>
        </div>
    </section>
</body>

</html>
