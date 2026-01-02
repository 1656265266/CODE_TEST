<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.library.dao.BookDAO" %>
        <%@ page import="java.util.List" %>
            <%@ page import="com.library.entity.Admin" %>

                <!DOCTYPE html>
                <html>

                <head>
                    <title>借阅记录管理</title>
                    <style>
                        body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            padding: 30px;
                            background-image: url('images/admin_bg.jpg');
                            background-size: cover;
                            background-attachment: fixed;
                        }

                        .container {
                            background: rgba(255, 255, 255, 0.95);
                            padding: 30px;
                            border-radius: 10px;
                            box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
                            max-width: 1200px;
                            margin: 0 auto;
                        }

                        h1 {
                            color: #2c3e50;
                            border-bottom: 2px solid #3498db;
                            padding-bottom: 10px;
                        }

                        .search-box {
                            margin: 20px 0;
                            display: flex;
                            gap: 10px;
                        }

                        .search-input {
                            flex: 1;
                            padding: 12px;
                            border: 1px solid #ddd;
                            border-radius: 5px;
                            font-size: 16px;
                        }

                        .search-btn {
                            padding: 12px 25px;
                            background: #3498db;
                            color: white;
                            border: none;
                            border-radius: 5px;
                            cursor: pointer;
                            font-size: 16px;
                        }

                        .search-btn:hover {
                            background: #2980b9;
                        }

                        .reset-btn {
                            padding: 12px 25px;
                            background: #95a5a6;
                            color: white;
                            text-decoration: none;
                            border-radius: 5px;
                            font-size: 16px;
                            display: inline-block;
                        }

                        .reset-btn:hover {
                            background: #7f8c8d;
                        }

                        table {
                            width: 100%;
                            border-collapse: collapse;
                            margin-top: 10px;
                        }

                        th,
                        td {
                            padding: 15px;
                            text-align: left;
                            border-bottom: 1px solid #ddd;
                        }

                        th {
                            background-color: #34495e;
                            color: white;
                        }

                        tr:hover {
                            background-color: #f1f1f1;
                        }

                        .back-btn {
                            display: inline-block;
                            margin-top: 20px;
                            padding: 10px 20px;
                            background: #7f8c8d;
                            color: white;
                            text-decoration: none;
                            border-radius: 5px;
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <% Admin admin=(Admin) session.getAttribute("currentUser"); 
                        if (admin==null) {
                            response.sendRedirect("login.jsp"); return; } 
                            %>

                            <div style="display:flex; justify-content:space-between; align-items:center;">
                                <h1>📜 全馆借阅记录查询</h1>
                                <a href="admin_dashboard.jsp" class="back-btn">⬅️ 返回控制台</a>
                            </div>

                            <% String keyword=request.getParameter("keyword"); %>
                                <form action="admin_records.jsp" method="get" class="search-box">
                                    <input type="text" name="keyword" class="search-input"
                                        placeholder="输入读者姓名、账号、书名或ISBN进行检索..."
                                        value="<%= keyword != null ? keyword : "" %>">
                                    <button type="submit" class="search-btn">🔍 搜索</button>
                                    <% if(keyword !=null && !keyword.isEmpty()) { %>
                                        <a href="admin_records.jsp" class="reset-btn">重置</a>
                                        <% } %>
                                </form>

                                <table>
                                    <thead>
                                        <tr>
                                            <th>读者姓名</th>
                                            <th>读者账号</th>
                                            <th>书名</th>
                                            <th>ISBN</th>
                                            <th>借出时间</th>
                                            <th>归还状态</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% BookDAO bookDAO=new BookDAO(); List<String[]> records;

                                            if (keyword != null && !keyword.trim().isEmpty()) {
                                            records = bookDAO.searchBorrowRecords(keyword);
                                            } else {
                                            records = bookDAO.getAllBorrowRecords();
                                            }

                                            if (records != null && records.size() > 0) {
                                            for (String[] record : records) {
                                            %>
                                            <tr>
                                                <td style="font-weight:bold; color:#2c3e50;">
                                                    <%= record[0] %>
                                                </td>
                                                <td>
                                                    <%= record[1] %>
                                                </td>
                                                <td style="color:#2980b9;">
                                                    <%= record[2] %>
                                                </td>
                                                <td>
                                                    <%= record[3] %>
                                                </td>
                                                <td>
                                                    <%= record[4] %>
                                                </td>
                                                <td>
                                                    <% if ("未归还".equals(record[5])) { %>
                                                        <span
                                                            style="color:red; font-weight:bold; background:#ffecec; padding:3px 8px; border-radius:4px;">未归还</span>
                                                        <% } else { %>
                                                            <span style="color:green;">
                                                                <%= record[5] %>
                                                            </span>
                                                            <% } %>
                                                </td>
                                            </tr>
                                            <% } } else { %>
                                                <tr>
                                                    <td colspan="6"
                                                        style="text-align:center; padding:30px; color:#7f8c8d; font-size:18px;">
                                                        没有找到相关记录 🍃
                                                    </td>
                                                </tr>
                                                <% } %>
                                    </tbody>
                                </table>
                    </div>
                </body>

                </html>