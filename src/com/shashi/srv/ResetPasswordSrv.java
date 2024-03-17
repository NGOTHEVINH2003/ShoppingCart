package com.shashi.srv;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.shashi.beans.UserBean;
import com.shashi.service.impl.UserServiceImpl;

/**
 *
 * @author Dinh Nguyen
 */
@WebServlet(name = "ResetPasswordSrv", urlPatterns = {"/ResetPasswordSrv"})
public class ResetPasswordSrv extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userName = request.getParameter("username");
                String oldPassword = request.getParameter("oldPassword");
		String newPassword = request.getParameter("newPassword");

		response.setContentType("text/html");

		String status = "Incorrect Username or password.";


			UserServiceImpl udao = new UserServiceImpl();

			status = udao.isValidCredential(userName, oldPassword);

			if (status.equalsIgnoreCase("valid")) {
				// valid user

                                udao.resetPassword(userName, newPassword);

				RequestDispatcher rd = request.getRequestDispatcher("login.jsp");

				rd.forward(request, response);

			} else {
				// invalid user;

				RequestDispatcher rd = request.getRequestDispatcher("register.jsp?message=" + status);

				rd.forward(request, response);

			}
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
