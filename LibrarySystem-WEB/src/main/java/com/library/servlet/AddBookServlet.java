package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.entity.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/addBook")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AddBookServlet extends HttpServlet {

    private BookDAO bookDAO = new BookDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            String isbn = req.getParameter("isbn");
            String bookName = req.getParameter("bookName");
            String author = req.getParameter("author");
            String publisher = req.getParameter("publisher");
            String category = req.getParameter("category");
            int stock = Integer.parseInt(req.getParameter("stock"));

            Part part = req.getPart("coverImage");
            String fileName = extractFileName(part);
            String savePath = "images/default_book.jpg";

            if (fileName != null && !fileName.isEmpty()) {
                String newFileName = UUID.randomUUID().toString() + "_" + fileName;
                String appPath = req.getServletContext().getRealPath("");
                String saveDir = appPath + File.separator + "images" + File.separator + "books";

                File fileDir = new File(saveDir);
                if (!fileDir.exists()) {
                    fileDir.mkdirs();
                }

                part.write(saveDir + File.separator + newFileName);
                savePath = "images/books/" + newFileName;
            }

            Book book = new Book();
            book.setIsbn(isbn);
            book.setBookName(bookName);
            book.setAuthor(author);
            book.setPublisher(publisher);
            book.setCategory(category);
            book.setTotalStock(stock);
            book.setCurrentStock(stock);
            book.setCoverImage(savePath);

            boolean success = bookDAO.addBook(book);

            if (success) {
                req.getSession().setAttribute("msg", "✅ 图书《" + bookName + "》入库成功！");
            } else {
                req.getSession().setAttribute("msg", "❌ 入库失败，可能是ISBN已存在。");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("msg", "❌ 系统错误：" + e.getMessage());
        }

        resp.sendRedirect("admin_dashboard.jsp");
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}