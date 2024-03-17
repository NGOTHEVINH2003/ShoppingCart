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
 * Servlet implementation class LoginSrv
 */
@WebServlet("/ForgotPasswordSrv")
public class ForgotPasswordSrv extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public ForgotPasswordSrv() {
		super();
	}

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

        @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}
