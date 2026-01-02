package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.entity.Admin;
import com.library.entity.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/addBook")
public class AddBookServlet extends HttpServlet {

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
        String bookName = req.getParameter("bookName");
        String author = req.getParameter("author");
        String publisher = req.getParameter("publisher");
        String category = req.getParameter("category");
        int stock = Integer.parseInt(req.getParameter("stock"));

        Book book = new Book();
        book.setIsbn(isbn);
        book.setBookName(bookName);
        book.setAuthor(author);
        book.setPublisher(publisher);
        book.setCategory(category);
        book.setTotalStock(stock);
        book.setCurrentStock(stock);

        boolean result = bookDAO.addBook(book);

        if (result) {
            session.setAttribute("msg", "✅ 图书入库成功！");
        } else {
            session.setAttribute("msg", "❌ 入库失败：可能ISBN已存在或其他错误。");
        }

        resp.sendRedirect("admin_dashboard.jsp");
    }
}