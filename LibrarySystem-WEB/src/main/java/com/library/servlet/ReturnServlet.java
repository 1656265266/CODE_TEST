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
        HttpSession session = req.getSession();
        Reader reader = (Reader) session.getAttribute("currentUser");
        String isbn = req.getParameter("isbn");

        if (reader == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

 
        String resultMsg = bookDAO.returnBook(isbn, reader.getReaderId());


        if (resultMsg.contains("成功")) {
         
            if (reader.getBorrowedCount() > 0) {
                reader.setBorrowedCount(reader.getBorrowedCount() - 1);
            }

            if (resultMsg.contains("逾期")) {
                
                session.setAttribute("msg", "⚠️ " + resultMsg);
            } else {
                session.setAttribute("msg", "✅ " + resultMsg);
            }
        } else {
            session.setAttribute("msg", "❌ " + resultMsg);
        }

        resp.sendRedirect("reader_dashboard.jsp");
    }
}