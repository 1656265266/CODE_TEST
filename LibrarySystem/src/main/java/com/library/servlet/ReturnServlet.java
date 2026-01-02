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

@WebServlet("/return")
public class ReturnServlet extends HttpServlet {

    private BookDAO bookDAO = new BookDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. 获取参数
        String isbn = req.getParameter("isbn");

        // 2. 获取当前读者
        HttpSession session = req.getSession();
        Reader reader = (Reader) session.getAttribute("currentUser");

        if (reader == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // 3. 执行还书
        boolean result = bookDAO.returnBook(isbn, reader.getReaderId());

        if (result) {
            // 更新session里的数量，让界面右上角数字立刻变
            reader.setBorrowedCount(reader.getBorrowedCount() - 1);
            session.setAttribute("msg", "✅ 还书成功！期待您再次借阅。");
        } else {
            session.setAttribute("msg", "❌ 还书失败：系统异常或该书已归还。");
        }

        // 4. 跳回
        resp.sendRedirect("reader_dashboard.jsp");
    }
}