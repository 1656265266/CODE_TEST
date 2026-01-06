<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <style>
        /* 全局基础样式 */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 50px;
            background-size: cover;
            background-attachment: fixed;
            background-position: center;
            margin: 0;
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
            /* 管理员标题色，读者页会被覆盖或通用 */
        }

        /* 按钮通用 */
        .btn {
            padding: 8px 15px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
            display: inline-block;
        }

        .btn:hover {
            background: #5a6268;
        }

        /* 表格通用 */
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

        /* 功能按钮 */
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

        .disabled-btn {
            background-color: #ccc;
            cursor: not-allowed;
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

        /* 消息提示 */
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

        .notification-box {
            background-color: #fff3cd;
            color: #856404;
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid #ffeeba;
            border-radius: 5px;
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

        /* 状态文字颜色 */
        .status-normal,
        .stock-ok {
            color: green;
            font-weight: bold;
        }

        .status-abnormal,
        .stock-missing,
        .stock-low {
            color: red;
            font-weight: bold;
        }

        /* 搜索框与筛选 */
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

        /* 分页组件 */
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
            font-size: 14px;
        }

        .page-link:hover {
            background-color: #f1f1f1;
        }

        .page-info {
            color: #666;
            margin: 0 10px;
            font-size: 14px;
        }

        .page-disabled {
            color: #ccc;
            cursor: not-allowed;
            pointer-events: none;
            background-color: #f9f9f9;
        }

        /* 管理员特定表单与统计 */
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

        input.valid {
            border: 2px solid #28a745 !important;
            background-color: #f0fff4;
        }

        input.invalid {
            border: 2px solid #dc3545 !important;
            background-color: #fff8f8;
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
    </style>