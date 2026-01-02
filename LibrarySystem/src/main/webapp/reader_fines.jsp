<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.library.entity.Reader" %>
        <%@ page import="com.library.entity.Fine" %>
            <%@ page import="com.library.dao.FineDAO" %>
                <%@ page import="java.util.List" %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <title>我的罚款通知</title>
                        <style>
                            body {
                                font-family: sans-serif;
                                padding: 50px;
                                background-image: url('images/reader_bg.jpg');
                                background-size: cover;
                                background-attachment: fixed;
                                background-position: center;
                            }

                            .card {
                                background: rgba(255, 255, 255, 0.95);
                                padding: 30px;
                                border-radius: 10px;
                                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
                                max-width: 800px;
                                margin: 0 auto;
                            }

                            h1 {
                                color: #dc3545;
                            }

                            .btn {
                                padding: 8px 15px;
                                background: #6c757d;
                                color: white;
                                text-decoration: none;
                                border-radius: 5px;
                                font-size: 14px;
                            }

                            .btn:hover {
                                background: #5a6268;
                            }

                            .back-btn {
                                background: #007bff;
                            }

                            .back-btn:hover {
                                background: #0056b3;
                            }

                            table {
                                width: 100%;
                                border-collapse: collapse;
                                margin-top: 20px;
                            }

                            th,
                            td {
                                padding: 12px;
                                border-bottom: 1px solid #ddd;
                                text-align: left;
                            }

                            th {
                                background-color: #dc3545;
                                color: white;
                            }

                            .pay-btn {
                                background-color: #28a745;
                                color: white;
                                border: none;
                                padding: 5px 15px;
                                border-radius: 3px;
                                cursor: pointer;
                            }

                            .status-paid {
                                color: #aaa;
                                font-style: italic;
                            }

                            .status-unpaid {
                                color: #dc3545;
                                font-weight: bold;
                            }

                            .alert-box {
                                background: #d4edda;
                                color: #155724;
                                padding: 10px;
                                border-radius: 5px;
                                margin-bottom: 15px;
                                border: 1px solid #c3e6cb;
                            }
                        </style>
                    </head>

                    <body>
                        <div class="card">
                            <% Reader reader=(Reader) session.getAttribute("currentUser"); if (reader==null) {
                                response.sendRedirect("login.jsp"); return; } FineDAO fineDAO=new FineDAO(); List<Fine>
                                fines = fineDAO.getFinesByReader(reader.getReaderId());
                                %>

                                <% String msg=(String) session.getAttribute("msg"); if (msg !=null) { %>
                                    <div class="alert-box">
                                        <%= msg %>
                                    </div>
                                    <% session.removeAttribute("msg"); } %>

                                        <div
                                            style="display: flex; justify-content: space-between; align-items: center;">
                                            <h1>⚠️ 违规罚款通知</h1>
                                            <a href="reader_dashboard.jsp" class="btn back-btn">⬅ 返回首页</a>
                                        </div>
                                        <hr>

                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>罚单ID</th>
                                                    <th>违规详情</th>
                                                    <th>金额 (元)</th>
                                                    <th>生成日期</th>
                                                    <th>状态</th>
                                                    <th>操作</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% if(fines !=null && fines.size()> 0) { for(Fine f : fines) { %>
                                                    <tr>
                                                        <td>
                                                            <%= f.getFineId() %>
                                                        </td>
                                                        <td>
                                                            <%= f.getReason() %>
                                                        </td>
                                                        <td style="font-size: 1.2em; font-weight: bold;">￥<%=
                                                                f.getAmount() %>
                                                        </td>
                                                        <td>
                                                            <%= f.getGeneratedDate() %>
                                                        </td>
                                                        <td class="<%= " 已缴纳".equals(f.getStatus()) ? "status-paid"
                                                            : "status-unpaid" %>">
                                                            <%= f.getStatus() %>
                                                        </td>
                                                        <td>
                                                            <% if("未缴纳".equals(f.getStatus())) { %>
                                                                <form action="payFine" method="post">
                                                                    <input type="hidden" name="fineId"
                                                                        value="<%= f.getFineId() %>">
                                                                    <button type="submit" class="pay-btn">💸
                                                                        立即缴纳</button>
                                                                </form>
                                                                <% } else { %>
                                                                    <span>✅ 完成</span>
                                                                    <% } %>
                                                        </td>
                                                    </tr>
                                                    <% }} else { %>
                                                        <tr>
                                                            <td colspan="6" style="text-align:center; padding:20px;">🎉
                                                                您信用良好，暂无罚款记录！</td>
                                                        </tr>
                                                        <% } %>
                                            </tbody>
                                        </table>
                        </div>
                    </body>

                    </html>