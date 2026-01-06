package com.library.servlet;

import com.library.dao.FineDAO;
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
        int fineId = Integer.parseInt(req.getParameter("fineId"));

        boolean success = fineDAO.payFine(fineId);

        if (success) {
            req.getSession().setAttribute("msg", "✅ 罚款缴纳成功！");
        } else {
            req.getSession().setAttribute("msg", "❌ 缴纳失败，请重试。");
        }

        resp.sendRedirect("reader_fines.jsp");
    }
}