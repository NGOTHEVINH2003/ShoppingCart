<%@page import="com.shashi.beans.ProductBean"%>
<%@page import="com.shashi.service.impl.ProductServiceImpl"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Add Product</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet"
              href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
        <script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script
        src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="css/changes.css">
    </head>
    <body style="background-color: #E6F9E6;">
        <%

            /* Checking the user credentials */
            String userType = (String) session.getAttribute("usertype");
            String userName = (String) session.getAttribute("username");
            String password = (String) session.getAttribute("password");

            if (userType == null || !userType.equals("admin")) {

                response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");

            } else if (userName == null || password == null) {

                response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");

            }
            String form = "";
            form = request.getParameter("form");
            String prodid = request.getParameter("prodid");
            ProductBean product = new ProductServiceImpl().getProductDetails(prodid);
            if (form != null) {
                if ((prodid == null || product == null) && form.equals("updateById")) {
                    response.sendRedirect("addProduct.jsp?message=Please Enter a valid product Id&form=update");
                    return;
                }
            }
        %>

        <jsp:include page="header.jsp" />

        <%
            String message = request.getParameter("message");
        %>
        <div class="container">
            <div class="row"
                 style="margin-top: 5px; margin-left: 2px; margin-right: 2px;">
                
                <% if (form == null || form.equals("add")) { %>
                <form action="./AddProductSrv" method="post"
                      enctype="multipart/form-data" class="col-md-6 col-md-offset-3"
                      style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;">
                    <div style="font-weight: bold;" class="text-center">
                        <h2 style="color: green;">Product Addition Form</h2>
                        <%
                            if (message != null) {
                        %>
                        <p style="color: blue;">
                            <%=message%>
                        </p>
                        <%
                            }
                        %>
                    </div>
                    <div></div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="last_name">Product Name</label> <input type="text"
                                                                               placeholder="Enter Product Name" name="name"
                                                                               class="form-control"
                                                                               id="last_name" required>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="producttype">Product Type</label> <select name="type"
                                                                                  id="producttype" class="form-control"
                                                                                  required>
                                <option value=2>MOBILE</option>
                                <option value=3>TV</option>
                                <option value=4>CAMERA</option>
                                <option value=1>LAPTOP</option>
                                <option value=5>SPEAKER</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="last_name">Product Description</label>
                        <textarea name="info" class="form-control" id="last_name" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="last_name">Unit Price</label> <input type="number"
                                                                             placeholder="Enter Unit Price" name="price"
                                                                             class="form-control"
                                                                             id="last_name" required>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="last_name">Stock Quantity</label> <input type="number"
                                                                                 placeholder="Enter Stock Quantity"
                                                                                 name="quantity"
                                                                                 class="form-control" id="last_name" required>
                        </div>
                    </div>
                    <div>
                        <div class="col-md-12 form-group">
                            <label for="last_name">Product Image</label> <input type="file"
                                                                                placeholder="Select Image" name="image"
                                                                                class="form-control"
                                                                                id="last_name" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 text-center" style="margin-bottom: 2px;">
                            <button type="reset" class="btn btn-danger">Reset</button>
                        </div>
                        <div class="col-md-6 text-center">
                            <button type="submit" class="btn btn-success">Add Product</button>
                        </div>
                    </div>
                </form>
                <%} else if (form.equals("updateById")) {%>
                <div class="row" style="width: 50%; margin: auto">
                    <div class="col-md-6 text-center">
                        <form action="./addProduct.jsp">
                            <input type="hidden" value="add" name="form">
                            <button type="submit" value="Add Product" class="btn btn-success">
                                Add Product
                            </button>
                        </form>
                    </div>

                </div>
                <form action="./UpdateProductSrv" method="post"
                      enctype="multipart/form-data" class="col-md-6 col-md-offset-3"
                      style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;">
                    <div style="font-weight: bold;" class="text-center">
                        <div class="form-group">
                            <img src="./ShowImage?pid=<%=product.getProdId()%>"
                                 alt="Product Image" height="100px"/>
                            <h2 style="color: green;">Product Update Form</h2>
                        </div>

                        <%
                            if (message != null) {
                        %>
                        <p style="color: blue;">
                            <%=message%>
                        </p>
                        <%
                            }
                        %>
                    </div>
                    <div class="row">
                        <input type="hidden" name="pid" class="form-control"
                               value="<%=product.getProdId()%>" id="last_name" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="last_name">Product Name</label> <input type="text"
                                                                               placeholder="Enter Product Name" name="name"
                                                                               class="form-control"
                                                                               value="<%=product.getProdName()%>" id="last_name"
                                                                               required>
                        </div>
                        <div class="col-md-6 form-group">
                            <%
                                int ptype = Integer.parseInt(product.getProdCategory());
                            %>
                            <label for="producttype">Product Type</label> <select name="type"
                                                                                  id="producttype" class="form-control"
                                                                                  required>
                                <option value="2"
                                        <%= ptype == 2 ? "selected" : ""%>>MOBILE
                                </option>
                                <option value="3"
                                        <%=ptype == 3 ? "selected" : ""%>>TV
                                </option>
                                <option value="4"
                                        <%=ptype == 4 ? "selected" : ""%>>CAMERA
                                </option>
                                <option value="1"
                                        <%=ptype == 1 ? "selected" : ""%>>LAPTOP
                                </option>
                                <option value="5"
                                        <%=ptype == 5 ? "selected" : ""%>>SPEAKER
                                </option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="last_name">Product Description</label>
                        <textarea name="info" class="form-control text-align-left"
                                  id="last_name" required><%=product.getProdInfo()%></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="last_name">Unit Price</label> <input type="number"
                                                                             value="<%=product.getProdPrice()%>"
                                                                             placeholder="Enter Unit Price" name="price"
                                                                             class="form-control"
                                                                             id="last_name" required>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="last_name">Stock Quantity</label> <input type="number"
                                                                                 value="<%=product.getProdQuantity()%>"
                                                                                 placeholder="Enter Stock Quantity"
                                                                                 class="form-control"
                                                                                 id="last_name" name="quantity" required>
                        </div>
                    </div>
                    <div>
                        <div class="col-md-12 form-group">
                            <label for="last_name">Product Image</label> <input type="file"
                                                                                placeholder="Select Image" name="image"
                                                                                class="form-control"
                                                                                id="last_name" required>
                        </div>
                    </div>
                    <div class="row text-center">
                        <div class="col-md-4" style="margin-bottom: 2px;">
                            <button formaction="adminViewProduct.jsp" class="btn btn-danger">Cancel</button>
                        </div>
                        <div class="col-md-4">
                            <button type="submit" class="btn btn-success">Update
                                Product
                            </button>
                        </div>
                    </div>
                </form>
                <%} else if (form.equals("update")) {%>
                <form action="./addProduct.jsp"
                      class="col-md-4 col-md-offset-4"
                      style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;">
                    <div style="font-weight: bold;" class="text-center">
                        <h3 style="color: green;">Product Update Form</h3>
                        <%
                            if (message != null) {
                        %>
                        <p style="color: blue;">
                            <%=message%>
                        </p>
                        <%
                            }
                        %>
                    </div>
                    <div></div>
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <label for="last_name">Product Id</label> <input type="text"
                                                                             placeholder="Enter Product Id" name="prodid"
                                                                             class="form-control"
                                                                             id="last_name" required>
                            <input type="hidden" value="updateById" name="form">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 text-center" style="margin-bottom: 2px;">
                            <a href="adminViewProduct.jsp" class="btn btn-info">Cancel</a>
                        </div>
                        <div class="col-md-6 text-center">
                            <button type="submit" class="btn btn-danger">Update
                                Product
                            </button>
                        </div>
                    </div>
                </form>
                <%}%>

            </div>
        </div>

        <%@ include file="footer.html"%>
    </body>
</html>