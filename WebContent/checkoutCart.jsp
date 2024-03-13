<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
    <!DOCTYPE html>
    <html>
        <head>
            <title>Payments</title>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet"
                  href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
            <link rel="stylesheet" href="css/changes.css">
            <script
            src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
            <script
            src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
            <style>
                .container {
                    display: flex;
                }
                .panel-left, .panel-right {
                    flex: 1;
                    height: 100%;
                }
                .panel-left {
                    flex: 1;
                    width: 50%;
                    background-color: lightblue;
                }
                .panel-right {
                    flex: 2;
                    width: 100%;
                    background-color: lightgreen;
                }
            </style>
        </head>
        <body style="background-color: #E6F9E6;">

            <%
                /* Checking the user credentials */
                String userName = (String) session.getAttribute("username");
                String password = (String) session.getAttribute("password");

                if (userName == null || password == null) {

                    response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
                }

                String sAmount = request.getParameter("amount");

                double amount = 0;

                if (sAmount != null) {
                    amount = Double.parseDouble(sAmount);
                }
                
                UserServiceImpl us = new UserServiceImpl();
                UserBean user = us.getUserDetails(userName, password);
            %>



            <jsp:include page="header.jsp" />

            <div class="container">
                <div class="panel-left">
                    <!-- Content for the left panel -->
                    <form>
                        <div style="font-weight: bold;" class="text-center">
                            <div class="form-group">
                                <h2 style="color: green;">Receiver Information</h2>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <label for="last_name">Receiver*</label> <input
                                    type="text" placeholder="Enter Receiver Name"  value="<%=user.getName()%>"
                                    name="cardholder" class="form-control" id="last_name" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <label for=email">Email*</label> 
                                <input
                                    type="text" placeholder="Enter Receiver Email"  value="<%=user.getEmail()%>"
                                    name="cardholder" class="form-control" id="last_name" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <label for="mobile">Mobile*</label> 
                                <input
                                    type="number" placeholder="Enter Receiver Phone" name="cardnumber" value="<%=user.getMobile()%>"
                                    class="form-control" id="last_name" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <label for="address">Address*</label> 
                                <input
                                    type="text" placeholder="Enter Receiver Address" value="<%=user.getAddress()%>"
                                    name="cardholder" class="form-control" id="last_name" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <label for="address">Payment Method</label> <br>
                                <input type="radio" name="paymentMethod" value="COD"> COD <br>
                                <input type="radio" name="paymentMethod" value="Visa Card"> Visa Card <br>
                                <input type="radio" name="paymentMethod" value="VNPost Payment"> VNPost Payment <br>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="panel-right">
                    <!-- Content for the right panel -->
                    <form>
                        <div style="font-weight: bold;" class="text-center">
                            <div class="form-group">
                                <h3>Products in cart</h3>
                                <table class="table table-hover">
                                    <thead
                                        style="background-color: #186188; color: white; font-size: 16px; font-weight: bold;">
                                        <tr>
                                            <th>Picture</th>
                                            <th>Products</th>
                                            <th>Price</th>
                                            <th>Quantity</th>
                                            <th>Amount</th>
                                        </tr>
                                    </thead>
                                    <tbody
                                        style="background-color: white; font-size: 15px; font-weight: bold;">



                                        <%
                                            CartServiceImpl cart = new CartServiceImpl();
                                            List<CartBean> cartItems = new ArrayList<CartBean>();
                                            cartItems = cart.getAllCartItems(userName);
                                            double totAmount = 0;

                                            for (CartBean item : cartItems) {

                                                String prodId = item.getProdId();

                                                int prodQuantity = item.getQuantity();

                                                ProductBean product = new ProductServiceImpl().getProductDetails(prodId);

                                                double currAmount = product.getProdPrice() * prodQuantity;

                                                totAmount += currAmount;

                                                if (prodQuantity > 0) {
                                        %>

                                        <tr id="row<%=product.getProdId()%>">
                                            <td><img src="./ShowImage?pid=<%=product.getProdId()%>"
                                                     style="width: 50px; height: 50px;"></td>
                                            <td><%=product.getProdName()%></td>
                                            <td id="price<%=product.getProdId()%>"><%=product.getProdPrice()%></td>
                                            <td><%=prodQuantity%></td>
                                            <td><%=currAmount%></td>
                                        </tr>

                                        <%
                                                }
                                            }
                                        %>

                                        <tr style="background-color: grey; color: white;">
                                            <td colspan="6" style="text-align: center;">Total Amount to
                                                Pay (in Rupees)</td>
                                            <td id="totalAmount"><%=totAmount%></td>
                                        </tr>
                                        <%
                                            if (totAmount != 0) {
                                        %>
                                        <tr style="background-color: grey; color: white;">
                                            <td colspan="4" style="text-align: center;">
                                            <td><form method="post">
                                                    <button formaction="cartDetails.jsp"
                                                            style="background-color: black; color: white;">Update</button>
                                                </form></td>
                                            <td colspan="2" align="center"><form method="post">
                                                    <button style="background-color: blue; color: white;"
                                                            formaction="payment.jsp?amount=<%=totAmount%>">Checkout</button>
                                                </form></td>

                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>             
                    </form>
                </div>
            </div>


            <%@ include file="footer.html"%>

        </body>
    </html>