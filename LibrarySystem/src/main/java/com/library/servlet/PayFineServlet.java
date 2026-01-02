package com.library.servlet;

import com.library.dao.FineDAO;
import com.library.entity.Reader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/payFine")
public class PayFineServlet extends HttpServlet {

    private FineDAO fineDAO = new FineDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fineIdStr = req.getParameter("fineId");
        if (fineIdStr == null || fineIdStr.isEmpty()) {
            resp.sendRedirect("reader_fines.jsp");
            return;
        }
        int fineId = Integer.parseInt(fineIdStr);

        Reader reader = (Reader) req.getSession().getAttribute("currentUser");
        if (reader == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        int readerId = reader.getReaderId();
        boolean success = fineDAO.payFine(fineId);

        if (success) {
            boolean hasRemaining = fineDAO.hasUnpaidFines(readerId);

            if (!hasRemaining) {
                reader.setStatus("正常");
                req.getSession().setAttribute("msg", "✅ 缴费成功！您的信用已恢复，账号自动解封。");
            } else {
                req.getSession().setAttribute("msg", "✅ 缴费成功！(注意：您仍有未缴罚单，账号暂保持冻结)");
            }
        } else {
            req.getSession().setAttribute("msg", "❌ 缴费失败：系统繁忙，请稍后再试。");
        }
        resp.sendRedirect("reader_fines.jsp");
    }
}