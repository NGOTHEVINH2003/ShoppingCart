package com.shashi.srv;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.shashi.service.impl.ProductServiceImpl;

@WebServlet("/RemoveProductSrv")
public class RemoveProductSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public RemoveProductSrv() {
        super();

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userType == null || !userType.equals("admin")) {

            response.sendRedirect("login.jsp?message=Access Denied, Login As Admin!!");

        } else if (userName == null || password == null) {

            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
        }

        // login checked
        String prodId = request.getParameter("prodid");
        String isActiveParam = request.getParameter("isActive");
        boolean s = Boolean.parseBoolean(isActiveParam);

        String type = request.getParameter("type");
        ProductServiceImpl product = new ProductServiceImpl();

        String status = product.removeProduct(prodId, s);

        if (type != null) {
            RequestDispatcher rd = request.getRequestDispatcher("adminStock.jsp");
            rd.forward(request, response);
        } else {

            RequestDispatcher rd = request.getRequestDispatcher("adminViewProduct.jsp");
            rd.forward(request, response);

        }

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }

}
