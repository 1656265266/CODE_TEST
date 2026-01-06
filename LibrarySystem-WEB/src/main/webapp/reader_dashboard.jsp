<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.library.entity.Reader" %>
        <%@ page import="com.library.entity.Book" %>
            <%@ page import="com.library.dao.BookDAO" %>
                <%@ page import="com.library.dao.UserDAO" %>
                    <%@ page import="java.util.List" %>
                        <%@ page import="java.util.ArrayList" %>

                            <!DOCTYPE html>
                            <html>

                            <head>
                                <title>读者中心</title>
                                <%@ include file="header.jsp" %>
                                    <style>
                                        body {
                                            background-image: url('images/reader_bg.png');
                                        }

                                        h1 {
                                            color: #007bff;
                                        }
                                    </style>
                            </head>

                            <body>

                                <div class="card">
                                    <% Reader sessionReader=(Reader) session.getAttribute("currentUser"); if
                                        (sessionReader==null) { response.sendRedirect("login.jsp"); return; } UserDAO
                                        userDAO=new UserDAO(); Reader
                                        reader=userDAO.getReaderById(sessionReader.getReaderId()); if (reader !=null) {
                                        session.setAttribute("currentUser", reader); } else { reader=sessionReader; }
                                        BookDAO bookDAO=new BookDAO(); String category=request.getParameter("category");
                                        if (category==null) category="全部" ; String
                                        keyword=request.getParameter("keyword"); if (keyword==null) keyword="" ; int
                                        currentPage=1; String pageStr=request.getParameter("page"); if (pageStr !=null
                                        && !pageStr.isEmpty()) { try { currentPage=Integer.parseInt(pageStr); } catch
                                        (NumberFormatException e) { currentPage=1; } } if (currentPage < 1)
                                        currentPage=1; int pageSize=10; int totalBooks=bookDAO.getBookCount(category,
                                        keyword); int totalPages=(int) Math.ceil((double) totalBooks / pageSize); if
                                        (totalPages < 1) totalPages=1; if (currentPage> totalPages) currentPage =
                                        totalPages;

                                        List<Book> bookList = bookDAO.getBooksByPage(category, keyword, currentPage,
                                            pageSize);
                                            List<Book> myBooks = bookDAO.getMyBorrowedBooks(reader.getReaderId());
                                                %>

                                                <% String msg=(String) session.getAttribute("msg"); if (msg !=null) { %>
                                                    <div class="<%= msg.contains(" 失败") || msg.contains("错误")
                                                        ? "alert-error" : "alert-box" %>">
                                                        <%= msg %>
                                                    </div>
                                                    <% session.removeAttribute("msg"); } %>

                                                        <% List<String> notifications =
                                                            userDAO.getReaderNotifications(reader.getReaderId());
                                                            if (notifications != null && !notifications.isEmpty()) {
                                                            %>
                                                            <div class="notification-box">
                                                                <h4 style="margin-top: 0;">🔔 消息提醒</h4>
                                                                <ul style="margin-bottom: 0; padding-left: 20px;">
                                                                    <% for (String notice : notifications) { %>
                                                                        <li>
                                                                            <%= notice %>
                                                                        </li>
                                                                        <% } %>
                                                                </ul>
                                                            </div>
                                                            <% } %>

                                                                <div
                                                                    style="display: flex; justify-content: space-between; align-items: center;">
                                                                    <div>
                                                                        <h1>📚 欢迎您，<%= reader.getName() %>
                                                                        </h1>
                                                                        <p>当前借阅数：<strong>
                                                                                <%= reader.getBorrowedCount() %>
                                                                            </strong> 本</p>
                                                                    </div>
                                                                    <div>
                                                                        <a href="reader_fines.jsp" class="btn"
                                                                            style="background-color: #dc3545; margin-right: 10px;">💸
                                                                            我的罚款</a>
                                                                        <a href="login.jsp" class="btn">退出登录</a>
                                                                    </div>
                                                                </div>

                                                                <h3>🎒 我的借阅清单</h3>
                                                                <% if (myBooks.size()==0) { %>
                                                                    <p
                                                                        style="color:#666; font-style:italic; background:#f8f9fa; padding:15px; border-radius:5px;">
                                                                        您当前没有正在借阅的图书，快去下面选一本吧！</p>
                                                                    <% } else { %>
                                                                        <table
                                                                            style="margin-bottom: 40px; border: 2px solid #007bff;">
                                                                            <thead style="background-color: #e3f2fd;">
                                                                                <tr>
                                                                                    <th>封面</th>
                                                                                    <th>已借书名</th>
                                                                                    <th>分类</th>
                                                                                    <th>作者</th>
                                                                                    <th>出版社</th>
                                                                                    <th>操作</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <% for (Book b : myBooks) { %>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <img src="<%= b.getCoverImage() %>"
                                                                                                alt="封面"
                                                                                                style="width: 60px; height: 80px; object-fit: cover; box-shadow: 2px 2px 5px rgba(0,0,0,0.2);">
                                                                                        </td>
                                                                                        <td><strong>
                                                                                                <%= b.getBookName() %>
                                                                                            </strong></td>
                                                                                        <td><span
                                                                                                style="background:#fff; padding:2px 8px; border-radius:10px; font-size:12px; border:1px solid #ccc;">
                                                                                                <%= b.getCategory()==null
                                                                                                    ? "未分类" :
                                                                                                    b.getCategory() %>
                                                                                            </span></td>
                                                                                        <td>
                                                                                            <%= b.getAuthor() %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= b.getPublisher() %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <form action="return"
                                                                                                method="post"
                                                                                                style="display:inline;">
                                                                                                <input type="hidden"
                                                                                                    name="isbn"
                                                                                                    value="<%= b.getIsbn() %>">
                                                                                                <button type="submit"
                                                                                                    class="borrow-btn"
                                                                                                    style="background-color:#ffc107; color:black;">归还</button>
                                                                                            </form>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <% } %>
                                                                            </tbody>
                                                                        </table>
                                                                        <% } %>
                                                                            <hr>

                                                                            <div
                                                                                style="display: flex; justify-content: space-between; align-items: center;">
                                                                                <h3>📖 图书馆藏列表</h3>
                                                                                <form action="reader_dashboard.jsp"
                                                                                    method="get" class="search-box"
                                                                                    style="margin: 0;">
                                                                                    <input type="hidden" name="category"
                                                                                        value="<%= category %>">
                                                                                    <input type="text" name="keyword"
                                                                                        class="search-input"
                                                                                        placeholder="在当前分类下搜索书名、作者..."
                                                                                        value="<%= keyword %>">
                                                                                    <button type="submit"
                                                                                        class="search-btn">🔍
                                                                                        搜索</button>
                                                                                    <% if ((keyword !=null &&
                                                                                        !keyword.isEmpty()) ||
                                                                                        !"全部".equals(category)) { %>
                                                                                        <a href="reader_dashboard.jsp"
                                                                                            class="btn"
                                                                                            style="margin-left:5px; background:#999;">重置</a>
                                                                                        <% } %>
                                                                                </form>
                                                                            </div>

                                                                            <div class="category-bar">
                                                                                <span class="category-label">📂
                                                                                    快速筛选：</span>
                                                                                <% String[] categories={"全部", "计算机"
                                                                                    , "文学" , "历史" , "科幻" , "悬疑" , "经济"
                                                                                    }; for (String cat : categories) {
                                                                                    boolean isActive=false; if
                                                                                    (cat.equals("全部")) { isActive="全部"
                                                                                    .equals(category) &&
                                                                                    keyword.isEmpty(); } else {
                                                                                    isActive=cat.equals(category); }
                                                                                    String linkUrl="?category=" + cat;
                                                                                    %>
                                                                                    <a href="<%= linkUrl %>"
                                                                                        class="category-tag <%= isActive ? "active" : "" %>"><%= cat %></a>
                                                                                    <% } %>
                                                                            </div>

                                                                            <table>
                                                                                <thead>
                                                                                    <tr>
                                                                                        <th>封面</th>
                                                                                        <th>书名</th>
                                                                                        <th>分类</th>
                                                                                        <th>作者</th>
                                                                                        <th>出版社</th>
                                                                                        <th>库存 (现货/总量)</th>
                                                                                        <th>操作</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody>
                                                                                    <% if (bookList !=null &&
                                                                                        bookList.size()> 0) {
                                                                                        for (Book b : bookList) {
                                                                                        String stockClass =
                                                                                        (b.getCurrentStock() > 0) ?
                                                                                        "stock-ok" : "stock-missing";
                                                                                        %>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <img src="<%= b.getCoverImage() %>"
                                                                                                    alt="封面"
                                                                                                    style="width: 60px; height: 80px; object-fit: cover; box-shadow: 2px 2px 5px rgba(0,0,0,0.2);">
                                                                                            </td>
                                                                                            <td>
                                                                                                <%= b.getBookName() %>
                                                                                            </td>
                                                                                            <td><span
                                                                                                    style="background:#f1f2f6; padding:2px 8px; border-radius:10px; font-size:12px;">
                                                                                                    <%= b.getCategory()==null
                                                                                                        ? "未分类" :
                                                                                                        b.getCategory()
                                                                                                        %>
                                                                                                </span></td>
                                                                                            <td>
                                                                                                <%= b.getAuthor() %>
                                                                                            </td>
                                                                                            <td>
                                                                                                <%= b.getPublisher() %>
                                                                                            </td>
                                                                                            <td>
                                                                                                <span
                                                                                                    class="<%= stockClass %>">
                                                                                                    <%=
                                                                                                        b.getCurrentStock()>
                                                                                                        0 ?
                                                                                                        b.getCurrentStock()
                                                                                                        : "缺货" %>
                                                                                                </span>
                                                                                                <% if
                                                                                                    (b.getCurrentStock()>
                                                                                                    0) { %> / <%=
                                                                                                        b.getTotalStock()
                                                                                                        %>
                                                                                                        <% } %>
                                                                                            </td>
                                                                                            <td>
                                                                                                <% if
                                                                                                    (b.getCurrentStock()>
                                                                                                    0) { %>
                                                                                                    <form
                                                                                                        action="borrow"
                                                                                                        method="post"
                                                                                                        style="display:inline;">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="isbn"
                                                                                                            value="<%= b.getIsbn() %>">
                                                                                                        <button
                                                                                                            type="submit"
                                                                                                            class="borrow-btn">借阅</button>
                                                                                                    </form>
                                                                                                    <% } else { %>
                                                                                                        <button
                                                                                                            class="borrow-btn disabled-btn"
                                                                                                            disabled>暂不可借</button>
                                                                                                        <% } %>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <% } } else { %>
                                                                                            <tr>
                                                                                                <td colspan="7"
                                                                                                    style="text-align:center; padding:20px; color:#666;">
                                                                                                    没有找到相关图书。</td>
                                                                                            </tr>
                                                                                            <% } %>
                                                                                </tbody>
                                                                            </table>

                                                                            <div class="pagination">
                                                                                <% if (currentPage> 1) { %>
                                                                                    <a href="reader_dashboard.jsp?page=<%= currentPage - 1 %>&keyword=<%= keyword %>&category=<%= category %>"
                                                                                        class="page-link">上一页</a>
                                                                                    <% } else { %>
                                                                                        <span
                                                                                            class="page-link page-disabled">上一页</span>
                                                                                        <% } %>

                                                                                            <span class="page-info">第
                                                                                                <%= currentPage %> 页 / 共
                                                                                                    <%= totalPages %>
                                                                                                        页</span>

                                                                                            <% if (currentPage <
                                                                                                totalPages) { %>
                                                                                                <a href="reader_dashboard.jsp?page=<%= currentPage + 1 %>&keyword=<%= keyword %>&category=<%= category %>"
                                                                                                    class="page-link">下一页</a>
                                                                                                <% } else { %>
                                                                                                    <span
                                                                                                        class="page-link page-disabled">下一页</span>
                                                                                                    <% } %>
                                                                            </div>
                                </div>

                            </body>

                            </html>