<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.library.entity.Reader" %>
        <%@ page import="com.library.entity.Fine" %>
            <%@ page import="com.library.dao.FineDAO" %>
                <%@ page import="java.util.List" %>
                    <%@ page import="java.text.SimpleDateFormat" %>

                        <!DOCTYPE html>
                        <html>

                        <head>
                            <title>我的罚款</title>
                            <%@ include file="header.jsp" %>
                                <style>
                                    body {
                                        background-image: url('images/reader_bg.png');
                                    }

                                    .paid {
                                        color: green;
                                        font-weight: bold;
                                    }

                                    .unpaid {
                                        color: red;
                                        font-weight: bold;
                                    }
                                </style>
                        </head>

                        <body>

                            <div class="card">
                                <% Reader reader=(Reader) session.getAttribute("currentUser"); if (reader==null) {
                                    response.sendRedirect("login.jsp"); return; } FineDAO fineDAO=new FineDAO();
                                    List<Fine> fines = fineDAO.getFinesByReaderId(reader.getReaderId());
                                    %>

                                    <div style="display: flex; justify-content: space-between; align-items: center;">
                                        <div>
                                            <h1>💸 我的罚款记录</h1>
                                            <p>请及时处理您的逾期罚款。</p>
                                        </div>
                                        <div>
                                            <a href="reader_dashboard.jsp" class="btn">🔙 返回首页</a>
                                        </div>
                                    </div>
                                    <hr>

                                    <% String msg=(String) session.getAttribute("msg"); if (msg !=null) { %>
                                        <div class="<%= msg.contains(" 失败") ? "alert-error" : "alert-box" %>">
                                            <%= msg %>
                                        </div>
                                        <% session.removeAttribute("msg"); } %>

                                            <table>
                                                <thead>
                                                    <tr>
                                                        <th>罚款单号</th>
                                                        <th>关联图书 (ISBN)</th>
                                                        <th>罚款金额</th>
                                                        <th>产生时间</th>
                                                        <th>状态</th>
                                                        <th>操作</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% if (fines !=null && fines.size()> 0) {
                                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                                                        for (Fine f : fines) {
                                                        boolean isPaid = "已缴纳".equals(f.getStatus());
                                                        %>
                                                        <tr>
                                                            <td>#<%= f.getFineId() %>
                                                            </td>
                                                            <td>
                                                                <%= f.getIsbn() %>
                                                            </td>
                                                            <td>¥ <%= String.format("%.2f", f.getAmount()) %>
                                                            </td>
                                                            <td>
                                                                <%= sdf.format(f.getGeneratedDate()) %>
                                                            </td>
                                                            <td>
                                                                <span class="<%= isPaid ? " paid" : "unpaid" %>">
                                                                    <%= f.getStatus() %>
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <% if (!isPaid) { %>
                                                                    <form action="payFine" method="post"
                                                                        style="margin:0;">
                                                                        <input type="hidden" name="fineId"
                                                                            value="<%= f.getFineId() %>">
                                                                        <button type="submit" class="borrow-btn"
                                                                            style="background-color: #e67e22;">立即缴费</button>
                                                                    </form>
                                                                    <% } else { %>
                                                                        <span style="color:#aaa;">-</span>
                                                                        <% } %>
                                                            </td>
                                                        </tr>
                                                        <% } } else { %>
                                                            <tr>
                                                                <td colspan="6"
                                                                    style="text-align:center; padding:20px; color:#666;">
                                                                    🎉 恭喜，您当前没有违规罚款记录！
                                                                </td>
                                                            </tr>
                                                            <% } %>
                                                </tbody>
                                            </table>
                            </div>

                        </body>

                        </html>