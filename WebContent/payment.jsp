
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.net.URLDecoder"%>
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
        </head>
        <body>
            <%
                String userName = (String) session.getAttribute("username");
                String name = (String) session.getAttribute("name");
                Long phone = (Long) session.getAttribute("phone");
                String address = (String) session.getAttribute("address");

                String buyNow = request.getParameter("buyNow");


            %>
            <form action="./OrderServlet" method="post">
                <div class="container">
                    <h1>Giỏ hàng thanh toán</h1>
                    <div class="info-wrapper">
                        <div class="receiver-info col-md-3">
                            <h2>Thông tin người nhận</h2>
                            <ul class="list-unstyled">
                                <% if (userName != null) {%>
                                <li><span>Họ tên:</span><br/>
                                    <label>
                                        <input type="text" value="<%=name%>">
                                    </label></li>
                                <li><span>Email:</span><br/>
                                    <label>
                                        <input type="text" name="username" value="<%=userName%>" required>
                                    </label></li>
                                <li><span>Điện thoại:</span><br/>
                                    <label>
                                        <input type="text" value="<%=phone%>">
                                    </label></li>
                                <li><span>Địa chỉ:</span><br/>
                                    <label>
                                        <input type="text" value="<%=address%>">
                                    </label></li>
                                    <% } else { %>
                                <li><span>Họ tên:</span><br/>
                                    <label>
                                        <input type="text">
                                    </label></li>
                                <li><span>Email:</span><br/>
                                    <label>
                                        <input type="text" name="username" required>
                                    </label></li>
                                <li><span>Điện thoại:</span><br/>
                                    <label>
                                        <input type="text">
                                    </label></li>
                                <li><span>Địa chỉ:</span><br/>
                                    <label>
                                        <input type="text">
                                    </label></li>
                                    <% } %>
                            </ul>
                            <div class="payment-method">
                                <h2>Phương thức thanh toán</h2>
                                <ul class="list-unstyled">
                                    <li>
                                        <input type="radio" name="payment" id="cod" checked>
                                        <label for="cod">Thanh toán khi nhận hàng</label>
                                    </li>
                                    <li>
                                        <input type="radio" name="payment" id="visa">
                                        <label for="visa">Thanh toán bằng thẻ Visa</label>
                                    </li>
                                    <li>
                                        <input type="radio" name="payment" id="vnpost">
                                        <label for="vnpost">Thanh toán qua VNPost</label>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="products-in-cart col-md-9">
                            <h2>Sản phẩm trong giỏ hàng</h2>
                            <% if (buyNow == null) { %>

                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Mã sản phẩm</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Danh mục</th>
                                        <th>Giá</th>
                                        <th>Số lượng</th>
                                        <th>Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <%
                                        CartServiceImpl cart = new CartServiceImpl();
                                        List<CartBean> cartItems = new ArrayList<CartBean>();
                                        if (userName == null) {
                                            Cookie[] cookies = request.getCookies();
                                            String cartJson = null;
                                            if (cookies != null) {
                                                for (Cookie cookie : cookies) {
                                                    if (cookie.getName().equals("cart")) {
                                                        try {
                                                            cartJson = URLDecoder.decode(cookie.getValue(), "UTF-8");
                                                            break;
                                                        } catch (UnsupportedEncodingException e) {
                                                            e.printStackTrace();
                                                        }
                                                    }
                                                }
                                            }

                                            if (cartJson != null) {
                                                JSONObject jsonArray = new JSONObject(cartJson);
                                                Iterator<String> keys = jsonArray.keys();
                                                while (keys.hasNext()) {
                                                    String key = keys.next();
                                                    int quantity = jsonArray.getInt(key);
                                                    CartBean cartItem = new CartBean();
                                                    cartItem.setProdId(key);
                                                    cartItem.setQuantity(quantity);
                                                    cartItems.add(cartItem);
                                                }
                                            }
                                        } else {
                                            cartItems = cart.getAllCartItems(userName);
                                        }
                                        double totAmount = 0;
                                        int totQuantity = 0;
                                        for (CartBean item : cartItems) {

                                            String prodId = item.getProdId();

                                            int prodQuantity = item.getQuantity();

                                            ProductBean product = new ProductServiceImpl().getProductDetails(prodId);

                                            double currAmount = product.getProdPrice() * prodQuantity;

                                            totAmount += currAmount;

                                            totQuantity += prodQuantity;

                                            if (prodQuantity > 0) {
                                    %>

                                    <tr>
                                        <td><%=product.getProdId()%></td>
                                        <td><%=product.getProdName()%></td>
                                        <td><%=product.getProdCategory()%></td>
                                        <td><%=product.getProdPrice()%></td>
                                        <td><%=prodQuantity%></td>
                                        <td><%=product.getProdPrice() * prodQuantity%></td>
                                    </tr>

                                    <%
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>

                            <div class="order-summary">
                                <p>Tổng số sản phẩm: <%=totQuantity%></p>
                                <p>Phí vận chuyển: 0</p>
                                <p>Tổng cộng: <%=totAmount%></p>
                                <input type="hidden" name="amount" value="<%=totAmount%>">
                            </div>
                            <div class="buttons">
                                <button class="btn btn-primary btn-checkout">Thanh toán</button>
                            </div>
                            <% } else {%>
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Mã sản phẩm</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Danh mục</th>
                                        <th>Giá</th>
                                        <th>Số lượng</th>
                                        <th>Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><%=request.getParameter("pid")%></td>
                                        <td><%=request.getParameter("pName")%></td>
                                        <td><%=request.getParameter("pType")%></td>
                                        <td><%=request.getParameter("amount")%></td>
                                        <td>1</td>
                                        <td><%=request.getParameter("amount")%></td>
                                    </tr>
                                </tbody>
                            </table>

                            <div class="order-summary">
                                <p>Tổng số sản phẩm: 1</p>
                                <p>Phí vận chuyển: 0</p>
                                <p>Tổng cộng: <%=request.getParameter("amount")%></p>
                                <input type="hidden" name="amount" value="<%=request.getParameter("amount")%>">
                            </div>

                            <div class="buttons">
                                <button class="btn btn-primary btn-checkout">Thanh toán</button>
                            </div>

                            <%}%>
                        </div>
                    </div>
                </div>
            </form>
            <jsp:include page="footer.jsp"/>
            </body>
        </html>