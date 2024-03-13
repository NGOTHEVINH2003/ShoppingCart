<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
    <!DOCTYPE html>
    <html>
        <head>
            <title>Cart Details</title>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet"
                  href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
            <link rel="stylesheet" href="css/changes.css">
            <script
            src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
            <script
            src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
            <link rel="stylesheet"
                  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

            <script>
                function quantityChanged(pid, qty) {

                    //Change Quantity
                    var qtyElement = document.getElementById('qty' + pid);

                    var qtyValue = parseInt(qtyElement.value);
                    var newValue = qtyValue + qty;
                    qtyElement.value = newValue;
                    
                    //Change amount
                    var amountText = document.getElementById('amount' +pid);
                    var priceText = document.getElementById('price' +pid);
                    var totalAmountText = document.getElementById("totalAmount");
                    
                    var oldAmount = parseFloat(amountText.innerHTML);
                    var price = parseFloat(priceText.innerHTML);
                    var oldTotal = parseFloat(totalAmountText.innerHTML);
                    
                    var newAmount = oldAmount + (qty * price);
                    var newTotal = oldTotal + (qty * price);
                    
                    amountText.innerHTML = newAmount.toFixed(1).toString();
                    totalAmountText.innerHTML = newTotal.toFixed(1).toString();
                    
                    $.ajax({
                        url: 'AddtoCart',
                        type: 'GET',
                        data: {
                            pid: pid,
                            pqty: qty
                        },
                        success: function (response) {
                            console.log('Product added to cart successfully.');
                            // Handle success response here if needed
                        },
                        error: function (xhr, status, error) {
                            console.error('Failed to add product to cart:', error);
                            // Handle error response here if needed
                        }
                    });

                }
                
                function removeProduct(pid) {
                    var amountText = document.getElementById('amount' +pid);
                    var totalAmountText = document.getElementById("totalAmount");
                    
                    var amount = parseFloat(amountText.innerHTML);
                    var oldTotal = parseFloat(totalAmountText.innerHTML);
                    
                    var newTotal = oldTotal - amount;

                    //Remove row
                    var rowElement = document.getElementById('row' + pid);
                    rowElement.remove();
                    
                    totalAmountText.innerHTML = newTotal.toFixed(1).toString();

                    $.ajax({
                        url: 'RemoveFromCart',
                        type: 'GET',
                        data: {
                            pid: pid,
                        },
                        success: function (response) {
                            console.log('Product removed cart successfully.');
                            // Handle success response here if needed
                        },
                        error: function (xhr, status, error) {
                            console.error('Failed to remove product from cart:', error);
                            // Handle error response here if needed
                        }
                    });


                }
            </script>
        </head>
        <body style="background-color: #E6F9E6;">

            <%
                /* Checking the user credentials */
                String userName = (String) session.getAttribute("username");
                String password = (String) session.getAttribute("password");

                if (userName == null || password == null) {

                    response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");

                }

                String addS = request.getParameter("add");
                if (addS != null) {

                    int add = Integer.parseInt(addS);
                    String uid = request.getParameter("uid");
                    String pid = request.getParameter("pid");
                    int avail = Integer.parseInt(request.getParameter("avail"));
                    int cartQty = Integer.parseInt(request.getParameter("qty"));
                    CartServiceImpl cart = new CartServiceImpl();

                    if (add == 1) {
                        //Add Product into the cart
                        cartQty += 1;
                        if (cartQty <= avail) {
                            cart.addProductToCart(uid, pid, 1);
                        } else {
                            response.sendRedirect("./AddtoCart?pid=" + pid + "&pqty=" + cartQty);
                        }
                    } else if (add == 0) {
                        //Remove Product from the cart
                        cart.removeProductFromCart(uid, pid);
                    }
                }
            %>



            <jsp:include page="header.jsp" />

            <div class="text-center"
                 style="color: green; font-size: 24px; font-weight: bold;">Cart
                Items</div>
            <!-- <script>document.getElementById('mycart').innerHTML='<i data-count="20" class="fa fa-shopping-cart fa-3x icon-white badge" style="background-color:#333;margin:0px;padding:0px; margin-top:5px;"></i>'</script>
            -->
            <!-- Start of Product Items List -->
            <div class="container">

                <table class="table table-hover">
                    <thead
                        style="background-color: #186188; color: white; font-size: 16px; font-weight: bold;">
                        <tr>
                            <th>Picture</th>
                            <th>Products</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Add</th>
                            <th>Remove</th>
                            <th>Amount</th>
                            <th>Action</th>
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
                            <td><form method="post" action="./UpdateToCart">
                                    <input id="qty<%=product.getProdId()%>" type="number" name="pqty" value="<%=prodQuantity%>"
                                           style="max-width: 70px;" min="0"> <input type="hidden"
                                           name="pid" value="<%=product.getProdId()%>"> <input
                                           type="submit" name="Update" value="Update"
                                           style="max-width: 80px;">
                                </form></td>
                            <td><a onclick="quantityChanged('<%=product.getProdId()%>', 1)"><i class="fa fa-plus"></i></a></td>
                            <td><a onclick="quantityChanged('<%=product.getProdId()%>', -1)"><i class="fa fa-minus"></i></a></td>
                            <td id="amount<%=product.getProdId()%>"><%=currAmount%></td>
                            <td><a onclick="removeProduct('<%=product.getProdId()%>')">Remove</a></td>
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
                                    <button formaction="userHome.jsp"
                                            style="background-color: black; color: white;">Buy more products</button>
                                </form></td>
                            <td colspan="2" align="center"><form method="post">
                                    <button style="background-color: blue; color: white;"
                                            formaction="checkoutCart.jsp?amount=<%=totAmount%>">Checkout</button>
                                </form></td>

                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <!-- ENd of Product Items List -->


            <%@ include file="footer.html"%>

        </body>
    </html>