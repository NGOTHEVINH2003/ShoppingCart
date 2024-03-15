package com.shashi.srv;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.shashi.beans.DemandBean;
import com.shashi.beans.ProductBean;
import com.shashi.service.impl.CartServiceImpl;
import com.shashi.service.impl.DemandServiceImpl;
import com.shashi.service.impl.ProductServiceImpl;
import java.net.URLDecoder;
import java.net.URLEncoder;
import jakarta.servlet.http.Cookie;
import org.json.JSONObject;

/**
 * Servlet implementation class AddtoCart
 */
@WebServlet("/AddtoCart")
public class AddtoCart extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public AddtoCart() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");
        String usertype = (String) session.getAttribute("usertype");

        // login Check Successfull
        String userId = userName;
        String prodId = request.getParameter("pid");
        int pQty = Integer.parseInt(request.getParameter("pqty")); // 1

        CartServiceImpl cart = new CartServiceImpl();

        ProductServiceImpl productDao = new ProductServiceImpl();

        ProductBean product = productDao.getProductDetails(prodId);

        int availableQty = product.getProdQuantity();

        int cartQty = cart.getProductCount(userId, prodId);

        pQty += cartQty;

        PrintWriter pw = response.getWriter();

        response.setContentType("text/html");

        if (userName == null || password == null || usertype == null || !usertype.equalsIgnoreCase("customer")) {
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

            // Create or update cart
            JSONObject cartJ;
            if (cartJson == null) {
                cartJ = new JSONObject();
            } else {
                cartJ = new JSONObject(cartJson);
            }
            if (pQty == 0) {
                cartJ.remove(prodId);
            } else {
                if (cartJ.has(prodId)) {
                    pQty += cartJ.getInt(prodId);
                }
                cartJ.put(prodId, pQty);
            }

            String updatedCartJson = cartJ.toString();

            Cookie cartCookie = new Cookie("cart", URLEncoder.encode(updatedCartJson, "UTF-8"));
            response.addCookie(cartCookie);
            response.sendRedirect("index.jsp");
        } else {
            if (pQty == cartQty) {
                String status = cart.removeProductFromCart(userId, prodId);

                jakarta.servlet.RequestDispatcher rd = request.getRequestDispatcher("userHome.jsp");

                rd.include(request, response);

                pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");
            } else if (availableQty < pQty) {

                String status = null;

                if (availableQty == 0) {
                    status = "Product is Out of Stock!";
                } else {

                    cart.updateProductToCart(userId, prodId, availableQty);

                    status = "Only " + availableQty + " no of " + product.getProdName()
                            + " are available in the shop! So we are adding only " + availableQty
                            + " products into Your Cart" + "";
                }
                DemandBean demandBean = new DemandBean(userName, product.getProdId(), pQty - availableQty);

                DemandServiceImpl demand = new DemandServiceImpl();

                boolean flag = demand.addProduct(demandBean);

                if (flag) {
                    status += "<br/>Later, We Will Mail You when " + product.getProdName()
                            + " will be available into the Store!";
                }

                jakarta.servlet.RequestDispatcher rd = request.getRequestDispatcher("cartDetails.jsp");

                rd.include(request, response);

                pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");

            } else {
                String status = cart.updateProductToCart(userId, prodId, pQty);

                jakarta.servlet.RequestDispatcher rd = request.getRequestDispatcher("userHome.jsp");

                rd.include(request, response);

                pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }

}
