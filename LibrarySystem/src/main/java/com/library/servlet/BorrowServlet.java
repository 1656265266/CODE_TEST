package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.entity.Reader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/borrow")
public class BorrowServlet extends HttpServlet {

    private BookDAO bookDAO = new BookDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String isbn = req.getParameter("isbn");

        HttpSession session = req.getSession();
        Reader reader = (Reader) session.getAttribute("currentUser");

        if (reader == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String resultMsg = bookDAO.borrowBook(isbn, reader.getReaderId());

        if ("Success".equals(resultMsg)) {
            reader.setBorrowedCount(reader.getBorrowedCount() + 1);
            session.setAttribute("msg", "✅ 借阅成功！请按时归还。");
        } else {
            session.setAttribute("msg", "❌ 借阅失败：" + resultMsg);
        }

        resp.sendRedirect("reader_dashboard.jsp");
    }
}