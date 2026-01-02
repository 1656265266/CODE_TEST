<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>图书馆系统登录</title>
        <style>
            /* -----------------------------------------------------------
           🚩 这里是控制背景图片的代码 🚩
           ----------------------------------------------------------- */
            body {
                /* 1. 设置背景图片路径：确保图片在 webapp/images/bg.jpg */
                background-image: url('images/login_bg.jpg');

                /* 2. 让背景图铺满整个屏幕，不重复 */
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center center;

                /* 3. 设置页面高度为视口高度，确保背景全屏 */
                height: 100vh;
                margin: 0;

                /* 4. 使用 Flexbox 让登录框在屏幕正中间 */
                display: flex;
                justify-content: center;
                align-items: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            /* ----------------------------------------------------------- */

            /* 登录框样式 */
            .login-card {
                background-color: rgba(255, 255, 255, 0.1);
                /* 白色背景，50%不透明度 */
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(255, 255, 255, 0.8);
                width: 350px;
                text-align: center;
            }

            h2 {
                color: #ffffff;
                margin-bottom: 20px;
            }

            .form-group {
                margin-bottom: 15px;
                text-align: left;
            }

            label {
                display: block;
                margin-bottom: 5px;
                color: #ffffff;
            }

            input[type="text"],
            input[type="password"] {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-sizing: border-box;
                /* 确保padding不撑大宽度 */
            }

            .role-group {
                display: flex;
                justify-content: space-around;
                margin-bottom: 20px;
            }

            button {
                width: 100%;
                padding: 12px;
                background-color: #007bff;
                /* 蓝色按钮 */
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
            }

            button:hover {
                background-color: #0056b3;
            }

            .error-message {
                color: red;
                background-color: #ffe6e6;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 15px;
                font-size: 14px;
            }
        </style>
    </head>

    <body>

        <div class="login-card">
            <h2>📚 图书馆管理系统</h2>

            <% String error=(String) request.getAttribute("errorMsg"); if (error !=null) { %>
                <div class="error-message">⚠️ <%= error %>
                </div>
                <% } %>

                    <form action="login" method="post">
                        <div class="form-group">
                            <label>账号</label>
                            <input type="text" name="username" placeholder="请输入账号 (如 admin_001)" required>
                        </div>

                        <div class="form-group">
                            <label>密码</label>
                            <input type="password" name="password" placeholder="请输入密码" required>
                        </div>

                        <div class="role-group">
                            <label><input type="radio" name="role" value="reader" checked> 读者</label>
                            <label><input type="radio" name="role" value="admin"> 管理员</label>
                        </div>

                        <button type="submit">立即登录</button>
                    </form>
        </div>

    </body>

    </html>