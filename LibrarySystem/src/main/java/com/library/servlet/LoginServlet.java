package com.library.servlet;

import com.library.dao.UserDAO;
import com.library.entity.Admin;
import com.library.entity.Reader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        HttpSession session = req.getSession();
        boolean loginSuccess = false;
        String errorMsg = "";

        if ("admin".equals(role)) {
            Admin admin = userDAO.loginAdmin(username, password);
            if (admin != null) {
                userDAO.generateDueWarnings();
                session.setAttribute("currentUser", admin);
                session.setAttribute("role", "admin");
                loginSuccess = true;
                resp.sendRedirect("admin_dashboard.jsp");
            } else {
                errorMsg = "管理员账号或密码错误！";
            }
        } else {
            Reader reader = userDAO.loginReader(username, password);
            if (reader != null) {
                userDAO.generateDueWarnings();
                session.setAttribute("currentUser", reader);
                session.setAttribute("role", "reader");
                loginSuccess = true;
                resp.sendRedirect("reader_dashboard.jsp");
            } else {
                errorMsg = "读者账号或密码错误，或账户已注销！";
            }
        }

        if (!loginSuccess) {
            req.setAttribute("errorMsg", errorMsg);
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect("login.jsp");
    }
}