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
                                <style>
                                    body {
                                        font-family: sans-serif;
                                        padding: 50px;
                                        background-image: url('images/reader_bg.png');
                                        background-size: cover;
                                        background-attachment: fixed;
                                        background-position: center;
                                    }

                                    .card {
                                        background: rgba(255, 255, 255, 0.95);
                                        padding: 30px;
                                        border-radius: 10px;
                                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
                                        max-width: 1000px;
                                        margin: 0 auto;
                                    }

                                    h1 {
                                        color: #007bff;
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
                                        background-color: #f8f9fa;
                                        color: #333;
                                    }

                                    tr:hover {
                                        background-color: #f1f1f1;
                                    }

                                    .borrow-btn {
                                        background-color: #28a745;
                                        color: white;
                                        border: none;
                                        padding: 5px 10px;
                                        border-radius: 3px;
                                        cursor: pointer;
                                    }

                                    .borrow-btn:hover {
                                        background-color: #218838;
                                    }

                                    .disabled-btn {
                                        background-color: #ccc;
                                        cursor: not-allowed;
                                    }

                                    .alert-box {
                                        background: #d4edda;
                                        color: #155724;
                                        padding: 10px;
                                        border-radius: 5px;
                                        margin-bottom: 15px;
                                        border: 1px solid #c3e6cb;
                                    }

                                    .alert-error {
                                        background: #f8d7da;
                                        color: #721c24;
                                        padding: 10px;
                                        border-radius: 5px;
                                        margin-bottom: 15px;
                                        border: 1px solid #f5c6cb;
                                    }

                                    .search-box {
                                        margin: 20px 0;
                                        display: flex;
                                        gap: 10px;
                                    }

                                    .search-input {
                                        flex: 1;
                                        padding: 10px;
                                        border: 1px solid #ddd;
                                        border-radius: 5px;
                                    }

                                    .search-btn {
                                        padding: 10px 20px;
                                        background: #007bff;
                                        color: white;
                                        border: none;
                                        border-radius: 5px;
                                        cursor: pointer;
                                    }

                                    .search-btn:hover {
                                        background: #0056b3;
                                    }

                                    .danger-banner {
                                        background-color: #ffdddd;
                                        border-left: 6px solid #f44336;
                                        color: #d8000c;
                                        padding: 15px;
                                        margin-bottom: 20px;
                                        font-weight: bold;
                                        display: flex;
                                        justify-content: space-between;
                                        align-items: center;
                                    }

                                    .pay-link {
                                        background: #f44336;
                                        color: white;
                                        text-decoration: none;
                                        padding: 5px 10px;
                                        border-radius: 4px;
                                        font-size: 14px;
                                    }

                                    .pay-link:hover {
                                        background: #d32f2f;
                                    }

                                    .status-normal {
                                        color: green;
                                        font-weight: bold;
                                    }

                                    .status-abnormal {
                                        color: red;
                                        font-weight: bold;
                                    }

                                    .stock-ok {
                                        color: green;
                                        font-weight: bold;
                                    }

                                    .stock-missing {
                                        color: red;
                                    }

                                    .category-bar {
                                        margin: 15px 0;
                                        display: flex;
                                        gap: 10px;
                                        align-items: center;
                                        flex-wrap: wrap;
                                    }

                                    .category-label {
                                        font-weight: bold;
                                        color: #555;
                                        font-size: 14px;
                                    }

                                    .category-tag {
                                        display: inline-block;
                                        padding: 6px 15px;
                                        background-color: #f1f2f6;
                                        color: #57606f;
                                        text-decoration: none;
                                        border-radius: 20px;
                                        font-size: 13px;
                                        transition: all 0.3s;
                                        border: 1px solid #dfe4ea;
                                    }

                                    .category-tag:hover {
                                        background-color: #eccc68;
                                        color: white;
                                        border-color: #eccc68;
                                        transform: translateY(-2px);
                                    }

                                    .category-tag.active {
                                        background-color: #007bff;
                                        color: white;
                                        border-color: #007bff;
                                        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
                                    }

                                    .notification-box {
                                        background-color: #fff3cd;
                                        color: #856404;
                                        padding: 15px;
                                        margin-bottom: 20px;
                                        border: 1px solid #ffeeba;
                                        border-radius: 5px;
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
                                        keyword=request.getParameter("keyword"); if (keyword==null) keyword="" ;
                                        List<Book> bookList = bookDAO.searchBooks(category, keyword);

                                        List<Book> myBooks = bookDAO.getMyBorrowedBooks(reader.getReaderId());
                                            boolean isAbnormal = "异常".equals(reader.getStatus()) ||
                                            "冻结".equals(reader.getStatus());
                                            String statusClass = isAbnormal ? "status-abnormal" : "status-normal";
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
                                                                <% for(String notice : notifications) { %>
                                                                    <li>
                                                                        <%= notice %>
                                                                    </li>
                                                                    <% } %>
                                                            </ul>
                                                        </div>
                                                        <% } %>

                                                            <% if (isAbnormal) { %>
                                                                <div class="danger-banner">
                                                                    <span>⚠️ 您的账号状态异常（有逾期罚款未缴），已暂停借阅功能！</span>
                                                                    <a href="reader_fines.jsp" class="pay-link">👉
                                                                        去缴纳罚款</a>
                                                                </div>
                                                                <% } %>

                                                                    <div
                                                                        style="display: flex; justify-content: space-between; align-items: center;">
                                                                        <div>
                                                                            <h1>📚 欢迎您，<%= reader.getName() %>
                                                                            </h1>
                                                                            <p>当前借阅数：<strong>
                                                                                    <%= reader.getBorrowedCount() %>
                                                                                </strong> 本 | 状态：<span
                                                                                    class="<%= statusClass %>">
                                                                                    <%= reader.getStatus() %>
                                                                                </span></p>
                                                                        </div>
                                                                        <div>
                                                                            <a href="reader_fines.jsp" class="btn"
                                                                                style="background-color: #dc3545; margin-right: 10px;">⚠️
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
                                                                                <thead
                                                                                    style="background-color: #e3f2fd;">
                                                                                    <tr>
                                                                                        <th>已借书名</th>
                                                                                        <th>分类</th>
                                                                                        <th>作者</th>
                                                                                        <th>出版社</th>
                                                                                        <th>操作</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody>
                                                                                    <% for(Book b : myBooks) { %>
                                                                                        <tr>
                                                                                            <td><strong>
                                                                                                    <%= b.getBookName()
                                                                                                        %>
                                                                                                </strong></td>
                                                                                            <td><span
                                                                                                    style="background:#fff; padding:2px 8px; border-radius:10px; font-size:12px; border:1px solid #ccc;">
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
                                                                                                <form action="return"
                                                                                                    method="post"
                                                                                                    style="display:inline;">
                                                                                                    <input type="hidden"
                                                                                                        name="isbn"
                                                                                                        value="<%= b.getIsbn() %>">
                                                                                                    <button
                                                                                                        type="submit"
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
                                                                                        <input type="hidden"
                                                                                            name="category"
                                                                                            value="<%= category %>">
                                                                                        <input type="text"
                                                                                            name="keyword"
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
                                                                                        , "文学" , "历史" , "科幻" , "悬疑"
                                                                                        , "经济" }; for (String cat :
                                                                                        categories) { boolean
                                                                                        isActive=false; if
                                                                                        (cat.equals("全部")) {
                                                                                        isActive="全部" .equals(category)
                                                                                        && keyword.isEmpty(); } else {
                                                                                        isActive=cat.equals(category); }
                                                                                        String linkUrl="?category=" +
                                                                                        cat; %>
                                                                                        <a href="<%= linkUrl %>"
                                                                                            class="category-tag <%= isActive ? "active" : "" %>"><%= cat %>
                                                                                                </a>
                                                                                        <% } %>
                                                                                </div>

                                                                                <table>
                                                                                    <thead>
                                                                                        <tr>
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
                                                                                            "stock-ok" :
                                                                                            "stock-missing";
                                                                                            %>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <%= b.getBookName()
                                                                                                        %>
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
                                                                                                    <%= b.getPublisher()
                                                                                                        %>
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
                                                                                                        0 &&
                                                                                                        !isAbnormal) {
                                                                                                        %>
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
                                                                                                        <% } else if
                                                                                                            (isAbnormal)
                                                                                                            { %>
                                                                                                            <button
                                                                                                                class="borrow-btn disabled-btn"
                                                                                                                disabled
                                                                                                                title="账号异常，请先处理罚款">暂停服务</button>
                                                                                                            <% } else {
                                                                                                                %>
                                                                                                                <button
                                                                                                                    class="borrow-btn disabled-btn"
                                                                                                                    disabled>暂不可借</button>
                                                                                                                <% } %>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <% } } else { %>
                                                                                                <tr>
                                                                                                    <td colspan="6"
                                                                                                        style="text-align:center; padding:20px; color:#666;">
                                                                                                        没有找到相关图书。</td>
                                                                                                </tr>
                                                                                                <% } %>
                                                                                    </tbody>
                                                                                </table>
                                </div>
                            </body>

                            </html>