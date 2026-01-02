<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.library.entity.Admin" %>
        <%@ page import="com.library.entity.Book" %>
            <%@ page import="com.library.dao.BookDAO" %>
                <%@ page import="java.util.List" %>
                    <%@ page import="java.util.ArrayList" %>

                        <!DOCTYPE html>
                        <html>

                        <head>
                            <title>管理员控制台</title>
                            <style>
                                body {
                                    font-family: sans-serif;
                                    padding: 50px;
                                    background-image: url('images/admin_bg.jpg');
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
                                    color: #2c3e50;
                                }

                                .btn {
                                    padding: 8px 15px;
                                    background: #e74c3c;
                                    color: white;
                                    text-decoration: none;
                                    border-radius: 5px;
                                    font-size: 14px;
                                }

                                .btn:hover {
                                    background: #c0392b;
                                }

                                .form-section {
                                    background-color: #f8f9fa;
                                    padding: 20px;
                                    border-radius: 8px;
                                    margin-bottom: 30px;
                                    border: 1px solid #e9ecef;
                                }

                                .form-row {
                                    display: flex;
                                    gap: 15px;
                                    margin-bottom: 15px;
                                }

                                .form-group {
                                    flex: 1;
                                }

                                .form-group label {
                                    display: block;
                                    margin-bottom: 5px;
                                    font-weight: bold;
                                    color: #555;
                                }

                                .form-group input,
                                .form-group select {
                                    width: 100%;
                                    padding: 8px;
                                    border: 1px solid #ccc;
                                    border-radius: 4px;
                                    box-sizing: border-box;
                                }

                                .submit-btn {
                                    background-color: #2c3e50;
                                    color: white;
                                    padding: 10px 20px;
                                    border: none;
                                    border-radius: 5px;
                                    cursor: pointer;
                                    font-size: 16px;
                                }

                                .submit-btn:hover {
                                    background-color: #1a252f;
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
                                    background-color: #2c3e50;
                                    color: white;
                                }

                                tr:hover {
                                    background-color: #f1f1f1;
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

                                .stock-ok {
                                    color: green;
                                    font-weight: bold;
                                }

                                .stock-low {
                                    color: red;
                                    font-weight: bold;
                                }

                                .delete-btn {
                                    background-color: #dc3545;
                                    color: white;
                                    border: none;
                                    padding: 5px 10px;
                                    border-radius: 3px;
                                    cursor: pointer;
                                    font-size: 12px;
                                }

                                .delete-btn:hover {
                                    background-color: #c82333;
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
                                    background: #2980b9;
                                    color: white;
                                    border: none;
                                    border-radius: 5px;
                                    cursor: pointer;
                                }

                                .search-btn:hover {
                                    background: #3498db;
                                }

                                .stat-box {
                                    display: flex;
                                    gap: 20px;
                                    margin-bottom: 20px;
                                }

                                .stat-card {
                                    flex: 1;
                                    background: #fff;
                                    padding: 20px;
                                    border-radius: 8px;
                                    text-align: center;
                                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                                    border-left: 5px solid #2c3e50;
                                }

                                .stat-num {
                                    font-size: 24px;
                                    font-weight: bold;
                                    color: #2c3e50;
                                    margin-top: 5px;
                                }

                                input.valid {
                                    border: 2px solid #28a745 !important;
                                    background-color: #f0fff4;
                                }

                                input.invalid {
                                    border: 2px solid #dc3545 !important;
                                    background-color: #fff8f8;
                                }

                                .pagination {
                                    display: flex;
                                    justify-content: center;
                                    align-items: center;
                                    margin-top: 20px;
                                    gap: 10px;
                                }

                                .page-link {
                                    padding: 8px 12px;
                                    background-color: #fff;
                                    border: 1px solid #ddd;
                                    text-decoration: none;
                                    color: #333;
                                    border-radius: 4px;
                                }

                                .page-link:hover {
                                    background-color: #f1f1f1;
                                }

                                .page-info {
                                    color: #666;
                                    margin: 0 10px;
                                }

                                .page-disabled {
                                    color: #ccc;
                                    cursor: not-allowed;
                                    pointer-events: none;
                                    background-color: #f9f9f9;
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
                                    background-color: #2c3e50;
                                    color: white;
                                    border-color: #2c3e50;
                                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
                                }
                            </style>
                            <script>
                                function confirmDelete(bookName) { return confirm("确定要下架图书《" + bookName + "》吗？\n下架后读者将无法检索到此书。"); }
                                function validateISBN(input) {
                                    const pattern = /^[0-9-Xx-]{10,20}$/;
                                    if (pattern.test(input.value.trim())) { input.classList.remove('invalid'); input.classList.add('valid'); }
                                    else { input.classList.remove('valid'); input.classList.add('invalid'); }
                                }
                            </script>
                        </head>

                        <body>
                            <div class="card">
                                <% Admin admin=(Admin) session.getAttribute("currentUser"); if (admin==null) {
                                    response.sendRedirect("login.jsp"); return; } BookDAO bookDAO=new BookDAO(); int[]
                                    stats=bookDAO.getLibraryStats(); String category=request.getParameter("category");
                                    if (category==null) category="全部" ; String keyword=request.getParameter("keyword");
                                    if (keyword==null) keyword="" ; int currentPage=1; String
                                    pageStr=request.getParameter("page"); if (pageStr !=null && !pageStr.isEmpty()) {
                                    try { currentPage=Integer.parseInt(pageStr); if (currentPage < 1) currentPage=1; }
                                    catch (NumberFormatException e) { currentPage=1; } } int pageSize=25; int
                                    totalBooks=bookDAO.getBookCount(category, keyword); int totalPages=(int)
                                    Math.ceil((double) totalBooks / pageSize); if (totalPages < 1) totalPages=1; if
                                    (currentPage> totalPages) currentPage = totalPages;

                                    List<Book> bookList = bookDAO.getBooksByPage(category, keyword, currentPage,
                                        pageSize);
                                        %>

                                        <% String msg=(String) session.getAttribute("msg"); if (msg !=null) { %>
                                            <div class="<%= msg.contains(" 失败") || msg.contains("错误") ? "alert-error"
                                                : "alert-box" %>">
                                                <%= msg %>
                                            </div>
                                            <% session.removeAttribute("msg"); } %>

                                                <div
                                                    style="display: flex; justify-content: space-between; align-items: center;">
                                                    <div>
                                                        <h1>👋 管理员控制台</h1>
                                                        <p>当前操作员：<%= admin.getName() %> (ID: <%= admin.getUsername() %>)
                                                        </p>
                                                    </div>
                                                    <div>
                                                        <a href="admin_records.jsp" class="btn"
                                                            style="background-color: #17a2b8; margin-right: 10px;">📜
                                                            查看借阅记录</a>
                                                        <a href="login.jsp" class="btn">退出登录</a>
                                                    </div>
                                                </div>
                                                <hr>

                                                <div class="stat-box">
                                                    <div class="stat-card" style="border-left-color: #3498db;">
                                                        <div>📚 馆藏总数</div>
                                                        <div class="stat-num">
                                                            <%= stats[0] %> 本
                                                        </div>
                                                    </div>
                                                    <div class="stat-card" style="border-left-color: #e67e22;">
                                                        <div>📤 已借出</div>
                                                        <div class="stat-num">
                                                            <%= stats[2] %> 本
                                                        </div>
                                                    </div>
                                                    <div class="stat-card" style="border-left-color: #27ae60;">
                                                        <div>✅ 当前在架</div>
                                                        <div class="stat-num">
                                                            <%= stats[1] %> 本
                                                        </div>
                                                    </div>
                                                </div>
                                                <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
                                                
                                                <div id="main"
                                                    style="width: 96%; height: 350px; background: white; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); padding: 20px;">
                                                </div>
                                                
                                                <script type="text/javascript">
                                                    var chartDom = document.getElementById('main');
                                                    var myChart = echarts.init(chartDom);
                                                    var option;

                                                    // 获取JSP后端传过来的数据
                                                    var totalStock = <%= stats[0] %>;
                                                    var currentStock = <%= stats[1] %>;
                                                    var borrowedStock = <%= stats[2] %>;

                                                    option = {
                                                        title: {
                                                            text: '📊 馆藏图书实时状态分布',
                                                            subtext: '总馆藏量：' + totalStock + ' 本',
                                                            left: 'center'
                                                        },
                                                        tooltip: {
                                                            trigger: 'item'
                                                        },
                                                        legend: {
                                                            orient: 'vertical',
                                                            left: 'left'
                                                        },
                                                        color: ['#27ae60', '#e67e22'], // 绿色代表在架，橙色代表借出
                                                        series: [
                                                            {
                                                                name: '图书状态',
                                                                type: 'pie',
                                                                radius: '50%',
                                                                data: [
                                                                    { value: currentStock, name: '✅ 当前在架' },
                                                                    { value: borrowedStock, name: '📤 已借出' }
                                                                ],
                                                                emphasis: {
                                                                    itemStyle: {
                                                                        shadowBlur: 10,
                                                                        shadowOffsetX: 0,
                                                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                                                    }
                                                                }
                                                            }
                                                        ]
                                                    };

                                                    option && myChart.setOption(option);
                                                </script>

                                                <h3>➕ 新书入库</h3>
                                                <div class="form-section">
                                                    <form action="addBook" method="post">
                                                        <div class="form-row">
                                                            <div class="form-group">
                                                                <label>ISBN (国际标准书号) <span
                                                                        style="color:red">*</span></label>
                                                                <input type="text" name="isbn" placeholder="请输入ISBN"
                                                                    pattern="[0-9-Xx-]{10,20}" title="格式错误"
                                                                    autocomplete="off" required
                                                                    oninput="validateISBN(this)">
                                                            </div>
                                                            <div class="form-group">
                                                                <label>图书名称 <span style="color:red">*</span></label>
                                                                <input type="text" name="bookName" placeholder="输入书名"
                                                                    required>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="form-group">
                                                                <label>作者 <span style="color:red">*</span></label>
                                                                <input type="text" name="author" placeholder="作者姓名"
                                                                    required>
                                                            </div>
                                                            <div class="form-group">
                                                                <label>出版社 <span style="color:red">*</span></label>
                                                                <input type="text" name="publisher" placeholder="出版社名称"
                                                                    required>
                                                            </div>
                                                            <div class="form-group">
                                                                <label>图书分类 <span style="color:red">*</span></label>
                                                                <select name="category">
                                                                    <option value="计算机">计算机</option>
                                                                    <option value="文学">文学</option>
                                                                    <option value="历史">历史</option>
                                                                    <option value="科幻">科幻</option>
                                                                    <option value="经济">经济</option>
                                                                    <option value="悬疑">悬疑</option>
                                                                    <option value="其他">其他</option>
                                                                </select>
                                                            </div>
                                                            <div class="form-group" style="flex: 0.5;">
                                                                <label>入库数量 <span style="color:red">*</span></label>
                                                                <input type="number" name="stock" placeholder="1-500"
                                                                    min="1" max="500" value="5" required>
                                                            </div>
                                                        </div>
                                                        <div style="text-align: right;">
                                                            <button type="submit" class="submit-btn">确认入库</button>
                                                        </div>
                                                    </form>
                                                </div>
                                                <hr>

                                                <div
                                                    style="display: flex; justify-content: space-between; align-items: center;">
                                                    <h3>📚 馆藏库存列表</h3>
                                                    <form action="admin_dashboard.jsp" method="get" class="search-box"
                                                        style="margin: 0;">
                                                        <input type="hidden" name="category" value="<%= category %>">
                                                        <input type="text" name="keyword" class="search-input"
                                                            placeholder="在当前分类下搜索书名、作者..." value="<%= keyword %>">
                                                        <button type="submit" class="search-btn">🔍 搜索</button>
                                                        <% if((keyword !=null && !keyword.isEmpty()) ||
                                                            !"全部".equals(category)) { %>
                                                            <a href="admin_dashboard.jsp" class="btn"
                                                                style="margin-left:5px; background:#999;">重置</a>
                                                            <% } %>
                                                    </form>
                                                </div>

                                                <div class="category-bar">
                                                    <span class="category-label">📂 快速筛选：</span>
                                                    <% String[] categories={"全部", "计算机" , "文学" , "历史" , "科幻" , "悬疑"
                                                        , "经济" }; for(String cat : categories) { boolean isActive=false;
                                                        if(cat.equals("全部")) { isActive="全部" .equals(category) &&
                                                        keyword.isEmpty(); } else { isActive=cat.equals(category); }
                                                        String linkUrl="?category=" + cat; %>
                                                        <a href="<%= linkUrl %>" class="category-tag <%= isActive ? "active" : "" %>"><%= cat %></a>
                                                        <% } %>
                                                </div>

                                                <table>
                                                    <thead>
                                                        <tr>
                                                            <th>ISBN</th>
                                                            <th>书名</th>
                                                            <th>分类</th>
                                                            <th>作者</th>
                                                            <th>出版社</th>
                                                            <th>总库存</th>
                                                            <th>当前在架</th>
                                                            <th>操作</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% if(bookList !=null && bookList.size()> 0) {
                                                            for(Book b : bookList) {
                                                            String cssClass = (b.getCurrentStock() > 0) ? "stock-ok" :
                                                            "stock-low";
                                                            %>
                                                            <tr>
                                                                <td>
                                                                    <%= b.getIsbn() %>
                                                                </td>
                                                                <td>
                                                                    <%= b.getBookName() %>
                                                                </td>
                                                                <td><span
                                                                        style="background:#f1f2f6; padding:2px 8px; border-radius:10px; font-size:12px;">
                                                                        <%= b.getCategory()==null ? "未分类" :
                                                                            b.getCategory() %>
                                                                    </span></td>
                                                                <td>
                                                                    <%= b.getAuthor() %>
                                                                </td>
                                                                <td>
                                                                    <%= b.getPublisher() %>
                                                                </td>
                                                                <td>
                                                                    <%= b.getTotalStock() %>
                                                                </td>
                                                                <td class="<%= cssClass %>">
                                                                    <%= b.getCurrentStock() %>
                                                                </td>
                                                                <td>
                                                                    <form action="deleteBook" method="post"
                                                                        onsubmit="return confirmDelete('<%= b.getBookName() %>');">
                                                                        <input type="hidden" name="isbn"
                                                                            value="<%= b.getIsbn() %>">
                                                                        <button type="submit"
                                                                            class="delete-btn">下架</button>
                                                                    </form>
                                                                </td>
                                                            </tr>
                                                            <% } } else { %>
                                                                <tr>
                                                                    <td colspan="8"
                                                                        style="text-align:center; padding:20px; color:#666;">
                                                                        没有找到相关图书。</td>
                                                                </tr>
                                                                <% } %>
                                                    </tbody>
                                                </table>

                                                <div class="pagination">
                                                    <% if (currentPage> 1) { %>
                                                        <a href="admin_dashboard.jsp?page=<%= currentPage - 1 %>&keyword=<%= keyword %>&category=<%= category %>"
                                                            class="page-link">上一页</a>
                                                        <% } else { %>
                                                            <span class="page-link page-disabled">上一页</span>
                                                            <% } %>
                                                                <span class="page-info">第 <%= currentPage %> 页 / 共 <%=
                                                                            totalPages %> 页 (共 <%= totalBooks %>
                                                                                条记录)</span>
                                                                <% if (currentPage < totalPages) { %>
                                                                    <a href="admin_dashboard.jsp?page=<%= currentPage + 1 %>&keyword=<%= keyword %>&category=<%= category %>"
                                                                        class="page-link">下一页</a>
                                                                    <% } else { %>
                                                                        <span class="page-link page-disabled">下一页</span>
                                                                        <% } %>
                                                </div>
                            </div>
                        </body>

                        </html>