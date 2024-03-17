<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
    <%@page import="org.json.JSONObject"%>
    <%@page import="java.net.URLDecoder"%>
    <!DOCTYPE html>
    <html>
        <head>
            <title>Ellison Electronics</title>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet"
                  href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
            <link rel="stylesheet" href="css/changes.css">
            <script
            src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
            <script
            src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
        </head>
        <body style="background-color: #E6F9E6;">

            <%
                /* Checking the user credentials */
                String userName = (String) session.getAttribute("username");
                String password = (String) session.getAttribute("password");
                String userType = (String) session.getAttribute("usertype");

                ProductServiceImpl prodDao = new ProductServiceImpl();
                List<ProductBean> products = new ArrayList<ProductBean>();

                String search = request.getParameter("search");
                String type = request.getParameter("type");
                String message = "All Products";
                if (search != null || type != null) {
                    products = prodDao.searchAllProducts(search, type);
                }
                if (products.isEmpty()) {
                    message = "No items found for the search '" + (search != null ? search : type) + "'";
                    products = prodDao.getAllProducts();
                }
            %>

            <jsp:include page="header.jsp" />

            <div class="text-center"
                 style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>
            <div class="text-center" id="message"
                 style="color: black; font-size: 14px; font-weight: bold;"></div>
            <!-- Start of Product Items List -->
            <div class="container">
                <div class="row text-center">
                    <%
                        Cookie[] cookies = request.getCookies();
                        String cartJson = null;

                        if (userName == null) {
                            if (cookies != null) {
                                for (Cookie cookie : cookies) {
                                    if (cookie.getName().equals("cart")) {
                                        cartJson = URLDecoder.decode(cookie.getValue(), "UTF-8");
                                        break;
                                    }
                                }
                            }

                            for (ProductBean product : products) {
                                JSONObject cart = (cartJson != null) ? new JSONObject(cartJson) : new JSONObject();
                                String prodId = product.getProdId();
                    %>
                    <div class="col-sm-4" style='height: 350px;'>
                        <div class="thumbnail">
                            <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
                                 style="height: 150px; max-width: 180px">
                            <p class="productname"><%=product.getProdName()%></p>
                            <%
                                String description = product.getProdInfo();
                                description = description.substring(0, Math.min(description.length(), 100));
                            %>
                            <p class="productinfo"><%=description%>..</p>
                            <p class="price">Rs<%=product.getProdPrice()%></p>
                            <form method="post">
                                <%
                                    if (!cart.has(prodId)) {
                                %>
                                <button type="submit"
                                        formaction="./AddtoCart?uid=<%=session.getId()%>&pid=<%=product.getProdId()%>&pqty=1"
                                        class="btn btn-success">Add to Cart</button>
                                &nbsp;&nbsp;&nbsp;
                                <button type="submit"
                                        formaction="payment.jsp?amount=<%=product.getProdPrice()%>&buyNow=1&pid=<%=product.getProdId()%>
                                        &pName=<%=product.getProdName()%>&pType=<%=product.getProdCategory()%>"
                                        class="btn btn-primary">Buy Now</button>
                                <%
                                } else {
                                %>
                                <button type="submit"
                                        formaction="./AddtoCart?uid=<%=session.getId()%>&pid=<%=product.getProdId()%>&pqty=0"
                                        class="btn btn-danger">Remove From Cart</button>
                                &nbsp;&nbsp;&nbsp;
                                <button type="submit"
                                        formaction="payment.jsp?amount=<%=product.getProdPrice()%>"
                                        class="btn btn-primary">Checkout</button>
                                <%
                                    }
                                %>
                            </form>
                            <br />
                        </div>
                    </div>
                    <%
                        }
                    } else {
                        for (ProductBean product : products) {
                            int cartQty = new CartServiceImpl().getCartItemCount(session.getId(), product.getProdId());
                    %>
                    <div class="col-sm-4" style='height: 350px;'>
                        <div class="thumbnail">
                            <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
                                 style="height: 150px; max-width: 180px">
                            <p class="productname"><%=product.getProdName()%></p>
                            <%
                                String description = product.getProdInfo();
                                description = description.substring(0, Math.min(description.length(), 100));
                            %>
                            <p class="productinfo"><%=description%>..</p>
                            <p class="price">Rs<%=product.getProdPrice()%></p>
                            <form method="post">
                                <%
                                    if (cartQty == 0) {
                                %>
                                <button type="submit"
                                        formaction="./AddtoCart?uid=<%=session.getId()%>&pid=<%=product.getProdId()%>&pqty=1"
                                        class="btn btn-success">Add to Cart</button>
                                &nbsp;&nbsp;&nbsp;
                                <button type="submit"
                                        formaction="./AddtoCart?uid=<%=session.getId()%>&pid=<%=product.getProdId()%>&pqty=1"
                                        class="btn btn-primary">Buy now</button>
                                <%
                                } else {
                                %>
                                <button type="submit"
                                        formaction="./AddtoCart?uid=<%=session.getId()%>&pid=<%=product.getProdId()%>&pqty=0"
                                        class="btn btn-danger">Remove From Cart</button>
                                &nbsp;&nbsp;&nbsp;
                                <button type="submit" formaction="cartDetails.jsp"
                                        class="btn btn-success">Checkout</button>
                                <%
                                    }
                                %>
                            </form>
                            <br />
                        </div>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>

            </div>
            <!-- ENd of Product Items List -->


            <jsp:include page="footer.jsp"/>

        </body>
    </html>