<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.library.entity.Admin" %>
        <%@ page import="com.library.dao.BookDAO" %>
            <%@ page import="java.util.List" %>
                <%@ page import="java.util.ArrayList" %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <title>借阅记录管理</title>
                        <%@ include file="header.jsp" %>
                            <style>
                                body {
                                    background-image: url('images/admin_bg.jpg');
                                }
                            </style>
                    </head>

                    <body>

                        <div class="card">
                            <% Admin admin=(Admin) session.getAttribute("currentUser"); if (admin==null) {
                                response.sendRedirect("login.jsp"); return; } %>

                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <div>
                                        <h1>📜 全馆借阅记录</h1>
                                        <p>查看所有图书的借阅和归还历史。</p>
                                    </div>
                                    <div>
                                        <a href="admin_dashboard.jsp" class="btn">🔙 返回控制台</a>
                                    </div>
                                </div>
                                <hr>

                                <%-- 搜索框区域 --%>
                                    <% String keyword=request.getParameter("keyword"); if (keyword==null) keyword="" ;
                                        %>
                                        <div
                                            style="display: flex; justify-content: space-between; align-items: center;">
                                            <h3>🔍 检索记录</h3>
                                            <form action="admin_records.jsp" method="get" class="search-box"
                                                style="margin: 0;">
                                                <input type="text" name="keyword" class="search-input"
                                                    placeholder="搜索读者、书名或ISBN..." value="<%= keyword %>">
                                                <button type="submit" class="search-btn">查询</button>
                                                <% if(keyword !=null && !keyword.isEmpty()) { %>
                                                    <a href="admin_records.jsp" class="btn"
                                                        style="margin-left: 5px; background: #999;">重置</a>
                                                    <% } %>
                                            </form>
                                        </div>

                                        <%-- 数据表格 --%>
                                            <table>
                                                <thead>
                                                    <tr>
                                                        <th>读者姓名</th>
                                                        <th>读者账号</th>
                                                        <th>借阅图书</th>
                                                        <th>ISBN</th>
                                                        <th>借出时间</th>
                                                        <th>归还状态/时间</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% BookDAO bookDAO=new BookDAO(); List<String[]> records;

                                                        // 根据关键字调用不同方法
                                                        if (keyword != null && !keyword.trim().isEmpty()) {
                                                        records = bookDAO.searchBorrowRecords(keyword);
                                                        } else {
                                                        records = bookDAO.getAllBorrowRecords();
                                                        }

                                                        if (records != null && records.size() > 0) {
                                                        for (String[] record : records) {
                                                        boolean isReturned = !"未归还".equals(record[5]);
                                                        String color = isReturned ? "green" : "red";
                                                        %>
                                                        <tr>
                                                            <td>
                                                                <%= record[0] %>
                                                            </td>
                                                            <td>
                                                                <%= record[1] %>
                                                            </td>
                                                            <td><strong>
                                                                    <%= record[2] %>
                                                                </strong></td>
                                                            <td>
                                                                <%= record[3] %>
                                                            </td>
                                                            <td>
                                                                <%= record[4] %>
                                                            </td>
                                                            <td style="color: <%= color %>; font-weight: bold;">
                                                                <%= record[5] %>
                                                            </td>
                                                        </tr>
                                                        <% } } else { %>
                                                            <tr>
                                                                <td colspan="6"
                                                                    style="text-align: center; padding: 20px; color: #666;">
                                                                    暂无相关借阅记录。
                                                                </td>
                                                            </tr>
                                                            <% } %>
                                                </tbody>
                                            </table>
                        </div>

                    </body>

                    </html>