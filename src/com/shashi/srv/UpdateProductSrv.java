package com.shashi.srv;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.shashi.beans.ProductBean;
import com.shashi.service.impl.ProductServiceImpl;
import jakarta.servlet.http.Part;
import java.io.InputStream;

/**
 * Servlet implementation class UpdateProductSrv
 */
@WebServlet("/UpdateProductSrv")
@MultipartConfig(maxFileSize = 16177215)
public class UpdateProductSrv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public UpdateProductSrv() {
        super();

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

//        if (userType == null || !userType.equals("admin")) {
//
//            response.sendRedirect("login.jsp?message=Access Denied, Login As Admin!!");
//            return;
//
//        } else if (userName == null || password == null) {
//
//            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
//            return;
//        }
        // Login success
        String prodId = request.getParameter("pid");
        String prodName = request.getParameter("name");
        System.out.println(request.getParameter("type"));
        String prodType = request.getParameter("type");
        String prodInfo = request.getParameter("info");

        double prodPrice = 0;
        Integer prodQuantity = 0;
        String priceParameter = request.getParameter("price");
        String quantityParameter = request.getParameter("quantity");
        if (priceParameter != null && quantityParameter != null) {
            try {
                prodPrice = Double.parseDouble(priceParameter);
                prodQuantity = Integer.parseInt(request.getParameter("quantity"));
                // Use prodPrice as needed
            } catch (NumberFormatException e) {
                // Handle the case where the parameter value is not a valid double
            }
        } else {
            // Handle the case where the "price" parameter is not present in the request
        }

        Part part = request.getPart("image");
        InputStream prodImage = null;
        if (part != null) {
            InputStream inputStream = part.getInputStream();
            // Do something with inputStream
             prodImage = inputStream;
            // Use prodImage as needed
        } else {
            // Handle the case where the "image" part is not present in the request
        }

        ProductBean product = new ProductBean();
        product.setProdId(prodId);
        product.setProdName(prodName);
        product.setProdInfo(prodInfo);
        product.setProdPrice(prodPrice);
        product.setProdQuantity(prodQuantity);
        product.setProdCategory(prodType);
        product.setProdImage(prodImage);

        ProductServiceImpl dao = new ProductServiceImpl();
        ProductBean prevProduct = dao.getProductDetails(prodId);
        String status = dao.updateProduct(prevProduct, product);

        RequestDispatcher rd = request
                .getRequestDispatcher("addProduct.jsp?prodid=" + prodId + "&message=" + status + "&form=updateById");
        rd.forward(request, response);

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }

}
