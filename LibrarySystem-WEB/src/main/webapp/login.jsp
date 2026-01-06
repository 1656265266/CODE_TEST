<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>图书馆系统登录</title>
        <style>
            body {
                background-image: url('images/login_bg.jpg');
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center center;
                height: 100vh;
                margin: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .login-card {
                background-color: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(10px);
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
            }

            .captcha-group {
                display: flex;
                gap: 10px;
                margin-bottom: 15px;
                text-align: left;
            }

            .captcha-input {
                flex: 1;
            }

            .captcha-img {
                cursor: pointer;
                border-radius: 5px;
                height: 40px;
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
                color: #721c24;
                background-color: #f8d7da;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 15px;
                font-size: 14px;
                border: 1px solid #f5c6cb;
            }
        </style>
        <script>
            function refreshCaptcha() {
                var img = document.getElementById("captchaImg");
                img.src = "captcha?t=" + new Date().getTime();
            }
        </script>
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

                        <div class="form-group">
                            <label>验证码</label>
                            <div class="captcha-group">
                                <input type="text" name="captcha" class="captcha-input" placeholder="输入验证码" required
                                    autocomplete="off">
                                <img id="captchaImg" src="captcha" class="captcha-img" onclick="refreshCaptcha()"
                                    title="点击刷新验证码">
                            </div>
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