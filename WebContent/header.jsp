<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.Iterator" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@page import="com.shashi.service.impl.*, com.shashi.service.*" %>
<%@page import="org.json.JSONObject" %>
<%@page import="jakarta.servlet.http.Cookie" %>
<%@page import="jakarta.servlet.http.HttpServletResponse" %>


<!DOCTYPE html>
<html>
<head>
    <title>Logout Header</title>
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
</head>
<body style="background-color: #E6F9E6;">
<!--Company Header Starting  -->
<div class="container-fluid text-center"
     style="margin-top: 45px; background-color: #33cc33; color: white; padding: 5px;">
    <h2>Ellison Electronics</h2>
    <h6>We specialize in Electronics</h6>
    <p align="center"
       style="color: blue; font-weight: bold; margin-top: 5px; margin-bottom: 5px;"
       id="message"></p>
</div>
<!-- Company Header Ending -->

<%
    Cookie[] cookies = request.getCookies();
    String cartJson = null;
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("cart")) {
                cartJson = URLDecoder.decode(cookie.getValue(), "UTF-8");
                break;
            }
        }
    }

    int count = 0;
    if (cartJson != null) {
        JSONObject cart = new JSONObject(cartJson);
        Iterator<String> keys = cart.keys();
        while (keys.hasNext()) {
            String key = keys.next();
            count += cart.getInt(key);
        }
    }
    /* Checking the user credentials */
    String userType = (String) session.getAttribute("usertype");
    if (userType == null) { //LOGGED OUT
%>

<!-- Starting Navigation Bar -->
<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header" style="width: 70%">
            <button type="button" class="navbar-toggle" data-toggle="collapse"
                    data-target="#myNavbar">
                <span class="icon-bar"></span> <span class="icon-bar"></span> <span
                    class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/"><span
                    class="glyphicon glyphicon-home">&nbsp;</span>Shopping Center</a>
            <ul class="nav navbar-nav navbar-left">
                <li><a href="/shopping-cart/">Products</a></li>
                <li class="dropdown"><a class="dropdown-toggle"
                                        data-toggle="dropdown" href="#">Category <span class="caret"></span>
                </a>
                    <ul class="dropdown-menu">
                        <li><a href="index.jsp">All</a></li>
                        <li><a href="index.jsp?type=mobile">Mobiles</a></li>
                        <li><a href="index.jsp?type=tv">TVs</a></li>
                        <li><a href="index.jsp?type=laptop">Laptops</a></li>
                        <li><a href="index.jsp?type=camera">Camera</a></li>
                        <li><a href="index.jsp?type=speaker">Speakers</a></li>
                        <li><a href="index.jsp?type=tablet">Tablets</a></li>
                    </ul>
                </li>
            </ul>
            <form class="form-inline" action="index.jsp" method="get" style="margin-top: 7px;">
                <div class="input-group">
                    <input type="text" class="form-control" size="20" name="search"
                           placeholder="Search Items" required>
                    <div class="input-group-btn">
                        <input type="submit" class="btn btn-danger" value="Search"/>
                    </div>
                </div>
            </form>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav navbar-right">
                <li><a href="cartDetails.jsp"
                       style="margin: 0px; padding: 0px;" id="mycart"><i
                        data-count="<%=count%>"
                        class="fa fa-shopping-cart fa-3x icon-white badge"
                        style="background-color: #333; margin: 0px; padding: 0px; padding-bottom: 0px; padding-top: 5px;">
                </i></a></li>
                <li><a href="register.jsp">Register</a></li>
                <li><a href="login.jsp">Login</a></li>
            </ul>
        </div>
    </div>
</nav>
<%
} else if ("customer".equalsIgnoreCase(userType)) { //CUSTOMER HEADER

    int notf = new CartServiceImpl().getCartCount((String) session.getAttribute("username"));
%>
<nav class="navbar navbar-default navbar-fixed-top">

    <div class="container-fluid">
        <div class="navbar-header" style="width: 70%">
            <button type="button" class="navbar-toggle" data-toggle="collapse"
                    data-target="#myNavbar">
                <span class="icon-bar"></span> <span class="icon-bar"></span> <span
                    class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="userHome.jsp"><span
                    class="glyphicon glyphicon-home">&nbsp;</span>Shopping Center</a>
            <ul class="nav navbar-nav navbar-left">
                <li><a href="userHome.jsp">Products</a></li>
                <li class="dropdown"><a class="dropdown-toggle"
                                        data-toggle="dropdown" href="#">Category <span class="caret"></span>
                </a>
                    <ul class="dropdown-menu">
                        <li><a href="userHome.jsp">All</a></li>
                        <li><a href="userHome.jsp?type=mobile">Mobiles</a></li>
                        <li><a href="userHome.jsp?type=tv">TV</a></li>
                        <li><a href="userHome.jsp?type=laptop">Laptops</a></li>
                        <li><a href="userHome.jsp?type=camera">Camera</a></li>
                        <li><a href="userHome.jsp?type=speaker">Speakers</a></li>
                        <li><a href="userHome.jsp?type=tablet">Tablets</a></li>
                    </ul>
                </li>
            </ul>
            <form class="form-inline" action="index.jsp" method="get" style="margin-top: 7px;">
                <div class="input-group">
                    <input type="text" class="form-control" size="20" name="search"
                           placeholder="Search Items" required>
                    <div class="input-group-btn">
                        <input type="submit" class="btn btn-danger" value="Search"/>
                    </div>
                </div>
            </form>
        </div>

        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav navbar-right">

                <%
                    if (notf == 0) {
                %>
                <li><a href="cartDetails.jsp"> <span
                        class="glyphicon glyphicon-shopping-cart"></span>Cart
                </a></li>

                <%
                } else {
                %>
                <li><a href="cartDetails.jsp"
                       style="margin: 0px; padding: 0px;" id="mycart"><i
                        data-count="<%=notf%>"
                        class="fa fa-shopping-cart fa-3x icon-white badge"
                        style="background-color: #333; margin: 0px; padding: 0px; padding-bottom: 0px; padding-top: 5px;">
                </i></a></li>
                <%
                    }
                %>
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">User<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="orderDetails.jsp">Orders</a></li>
                        <li><a href="userProfile.jsp">Profile</a></li>
                        <li><a href="./LogoutSrv">Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
<%
} else { //ADMIN HEADER
%>
<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header" style="width: 70%; max-width: 800px;">
            <button type="button" class="navbar-toggle" data-toggle="collapse"
                    data-target="#myNavbar">
                <span class="icon-bar"></span> <span class="icon-bar"></span> <span
                    class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="adminViewProduct.jsp"><span
                    class="glyphicon glyphicon-home">&nbsp;</span>Shopping Center</a>
            <ul class="nav navbar-nav navbar-left">
                <li><a href="adminViewProduct.jsp">Products</a></li>
                <li class="dropdown"><a class="dropdown-toggle"
                                        data-toggle="dropdown" href="#">Category <span class="caret"></span>
                </a>
                    <ul class="dropdown-menu">
                        <li><a href="adminViewProduct.jsp">All</a></li>
                        <li><a href="adminViewProduct.jsp?type=mobile">Mobiles</a></li>
                        <li><a href="adminViewProduct.jsp?type=tv">Tvs</a></li>
                        <li><a href="adminViewProduct.jsp?type=laptop">Laptops</a></li>
                        <li><a href="adminViewProduct.jsp?type=camera">Camera</a></li>
                        <li><a href="adminViewProduct.jsp?type=speaker">Speakers</a></li>
                        <li><a href="adminViewProduct.jsp?type=tablet">Tablets</a></li>
                    </ul>
                </li>
            </ul>
            <form class="form-inline" action="index.jsp" method="get" style="margin-top: 7px;">
                <div class="input-group">
                    <input type="text" class="form-control" size="20" name="search"
                           placeholder="Search Items" required>
                    <div class="input-group-btn">
                        <input type="submit" class="btn btn-danger" value="Search"/>
                    </div>
                </div>
            </form>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">Admin<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="adminStock.jsp">Stock</a></li>
                        <li><a href="shippedItems.jsp">Shipped</a></li>
                        <li><a href="unshippedItems.jsp">Orders</a></li>
                        <li><a href="addProduct.jsp">Add Product</a></li>
                        <li><a href="removeProduct.jsp">Remove Product</a></li>
                        <li><a href="updateProductById.jsp">Update Product</a></li>
                        <li><a href="./LogoutSrv">Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
<%
    }
%>
<!-- End of Navigation Bar -->
</body>
</html>