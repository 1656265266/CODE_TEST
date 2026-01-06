package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.entity.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/deleteBook")
public class DeleteBookServlet extends HttpServlet {

    private BookDAO bookDAO = new BookDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Admin admin = (Admin) session.getAttribute("currentUser");
        if (admin == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String isbn = req.getParameter("isbn");

        // 1. 下架前，先检查该书是否有未还的借阅记录
        if (bookDAO.hasActiveBorrows(isbn)) {
            // 如果有人还在借，禁止下架，并提示管理员
            session.setAttribute("msg", "❌ 下架失败：该书尚有未归还的副本，禁止下架！");
        } else {
            // 2. 只有没人借的时候，才真正执行下架
            boolean result = bookDAO.deleteBook(isbn);

            if (result) {
                session.setAttribute("msg", "✅ 图书已成功下架！");
            } else {
                session.setAttribute("msg", "❌ 下架失败：系统错误。");
            }
        }

        resp.sendRedirect("admin_dashboard.jsp");
    }
}