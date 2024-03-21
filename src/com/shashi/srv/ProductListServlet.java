/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.shashi.srv;

import com.shashi.beans.ProductBean;
import com.shashi.service.impl.ProductServiceImpl;
import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author DELL
 */
@WebServlet(name = "ProductListServlet", urlPatterns = {"/ProductListServlet"})

public class ProductListServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public ProductListServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        int recordsPerPage = 10; 
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
       
        ProductServiceImpl dao = new ProductServiceImpl();
        String categoryId = request.getParameter("categoryId");
        String searchKeyword = request.getParameter("searchKeyword");
        String isActiveParam = request.getParameter("isActive");

        boolean isActive = isActiveParam != null && !isActiveParam.isEmpty() ? Boolean.parseBoolean(isActiveParam) : false;
        List<ProductBean> productList = new ArrayList<>();
        productList = dao.getAllProductStock(categoryId, isActive, searchKeyword);
        
        int totalRecords = productList.size();
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

        List<ProductBean> currentPageProducts = dao.getProductsForPage(productList, page, recordsPerPage);

        request.setAttribute("productList", currentPageProducts);
        request.setAttribute("cateId", categoryId);
        request.setAttribute("isActive", isActive);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);

        RequestDispatcher rd = request.getRequestDispatcher("adminStock.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
