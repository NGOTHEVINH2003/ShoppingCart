

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
    <!DOCTYPE html>
    <html>
        <head>
            <title>Product Stocks</title>
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
                String userType = (String) session.getAttribute("usertype");
                String userName = (String) session.getAttribute("username");
                String password = (String) session.getAttribute("password");

                if (userType == null || !userType.equals("admin")) {

                    response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");

                } else if (userName == null || password == null) {

                    response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");

                }
            %>

            <jsp:include page="header.jsp" />
            <script>
                function updateProductList() {
                    var categoryId = document.getElementById("categoryId").value;
                    var isActive = document.getElementById("isActive").value;
                    var currentPage = <%= request.getAttribute("currentPage")%>;

                    var categoryIdSelect = document.getElementById("categoryId");
                    var isActiveSelect = document.getElementById("isActive");

                    for (var i = 0; i < categoryIdSelect.options.length; i++) {
                        if (categoryIdSelect.options[i].value == categoryId) {
                            categoryIdSelect.options[i].setAttribute("selected", "selected");
                        } else {
                            categoryIdSelect.options[i].removeAttribute("selected");
                        }
                    }

                    for (var i = 0; i < isActiveSelect.options.length; i++) {
                        if (isActiveSelect.options[i].value == isActive) {
                            isActiveSelect.options[i].setAttribute("selected", "selected");
                        } else {
                            isActiveSelect.options[i].removeAttribute("selected");
                        }
                    }

                    window.location.href = "./ProductListServlet?page=" + currentPage + "&categoryId=" + categoryId + "&isActive=" + isActive;

                }


            </script>
            <div class="text-center"
                 style="color: green; font-size: 24px; font-weight: bold;">Stock
                Products </div>
            <form method="post" class="text-center">
                <button type="submit"
                        formaction="addProduct.jsp"
                        class="btn btn-primary">Add Product</button>
            </form>
            <div class="container-fluid">
                <div class="row mb-3">
                    <!--                    <div class="col-md-6">
                                            <label for="searchKeyword">Search:</label>
                                            <input type="text" id="searchKeyword" name="searchKeyword" class="form-control">
                                        </div>
                                        <div class="col-md-6">
                                            <button type="button" onclick="searchProducts()" class="btn btn-primary">Search</button>
                                        </div>-->
                    <div class="col-md-6">
                        <label for="categoryId">Category:</label>
                        <select id="categoryId" name="categoryId" class="form-select" onchange="updateProductList()">
                            <option value="0" ${cateId eq '0' ? 'Selected' : ""}>All</option> 
                            <option value="2" ${cateId eq '2' ? 'Selected' : ""}>MOBILE</option>
                            <option value="3" ${cateId eq '3' ? 'Selected' : ""}>TV</option>
                            <option value="4" ${cateId eq '4' ? 'Selected' : ""}>CAMERA</option>
                            <option value="1" ${cateId eq '1' ? 'Selected' : ""}>LAPTOP</option>
                            <option value="5" ${cateId eq '5' ? 'Selected' : ""}>SPEAKER</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="isActive">Status:</label>
                        <select id="isActive" name="isActive" class="form-select" onchange="updateProductList()">
                            <option value="">All</option> 
                            <option value="true" ${isActive == true ? 'Selected':""}>Active</option>
                            <option value="false" ${isActive == false ? 'Selected':""}>Inactive</option>

                        </select>
                    </div>
                </div>
                <div class="table-responsive ">
                    <table class="table table-hover table-sm">
                        <thead
                            style="background-color: #2c6c4b; color: white; font-size: 18px;">
                            <tr>
                                <th>Image</th>
                                <th>ProductId</th>
                                <th>Name</th>
                                <th>Type</th>
                                <th>Price</th>
                                <th>Sale_Price</th>
                                <th>Sold Qty</th>
                                <th>Stock Qty</th>
                                <th>Status</th>
                                <th colspan="2" style="text-align: center">Actions</th>
                            </tr>
                        </thead>
                        <tbody style="background-color: white; font-size: 16px;">



                            <%
                                ProductServiceImpl dao = new ProductServiceImpl();
                                // L?y danh sách s?n ph?m cho trang hi?n t?i
                                List<ProductBean> currentPageProducts = (List<ProductBean>) request.getAttribute("productList");
                                if (currentPageProducts != null) {
                                    for (ProductBean product : currentPageProducts) {
                            %>

                            <tr>
                                <td><img src="./ShowImage?pid=<%=product.getProdId()%>"
                                         style="width: 50px; height: 50px;"></td>
                                <td><a
                                        href="./updateProduct.jsp?prodid=<%=product.getProdId()%>"><%=product.getProdId()%></a></td>
                                    <%
                                        String name = product.getProdName();
                                        name = name.substring(0, Math.min(name.length(), 25)) + "..";
                                    %>
                                <td><%=name%></td>
                                <td><%=product.getProdCategory()%></td>
                                <td><%=product.getProdPrice()%></td>
                                <td><%=Math.floor(product.getProdPrice() * 0.9)%>
                                <td><%=new OrderServiceImpl().countSoldItem(product.getProdId())%></td>
                                <td><%=product.getProdQuantity()%></td>
                                <% if (product.isActive()) { %>
                                <td>
                                    Active
                                </td>
                                <% } else { %>
                                <td>
                                    Inactive
                                </td> <% }%>
                                <td>
                                    <form method="post">
                                        <button type="submit"
                                                formaction="addProduct.jsp?prodid=<%=product.getProdId()%>&form=updateById"
                                                class="btn btn-primary">Update</button>
                                    </form>
                                </td>
                                <td>
                                    <form method="post">
                                        <% if (product.isActive()) {%>
                                        <button type="submit"
                                                formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>&status=false&type=admin"
                                                class="btn btn-danger">UnPublish
                                        </button>
                                        <%
                                        } else {
                                        %>    
                                        <button type="submit"
                                                formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>&status=true&type=admin"
                                                class="btn btn-success">Publish 
                                        </button>
                                        <% } %>
                                    </form>
                                </td>

                            </tr>

                            <%
                                    }
                                }
                            %>
                            <%
                                if (currentPageProducts.size() == 0) {
                            %>
                            <tr style="background-color: grey; color: white;">
                                <td colspan="7" style="text-align: center;">No Items 
                                    Available</td>

                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    <div class="text-center">
                        <% int totalPages = (int) request.getAttribute("totalPages");
                            int currentPage = (int) request.getAttribute("currentPage");
                            if (currentPage > 1) {%>
                        <a href="?page=<%= currentPage - 1%>" class="btn btn-primary">&laquo; Previous</a>
                        <% }
                            for (int i = 1; i <= totalPages; i++) {%>
                        <a href="?page=<%= i%>" class="btn btn-outline-primary<%= (currentPage == i) ? " active" : ""%>"><%= i%></a>
                        <% }
                            if (currentPage < totalPages) {%>
                        <a href="?page=<%= currentPage + 1%>" class="btn btn-primary">Next &raquo;</a>
                        <% }%>
                    </div>


                </div>
            </div>

            <%@ include file="footer.html"%>
        </body>
    </html>
