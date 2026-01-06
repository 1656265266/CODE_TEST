<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.library.util.DBUtil" %>

            <!DOCTYPE html>
            <html>

            <head>
                <title>DB Test</title>
            </head>

            <body>
                <h2>数据库连接测试</h2>
                <hr>
                <% 
                Connection conn=null; 
                Statement stmt=null; 
                ResultSet rs=null; 
                try { 
                    conn=DBUtil.getConnection();
                    String sql="SELECT COUNT(*) FROM Books" ; 
                    stmt=conn.createStatement(); 
                    rs=stmt.executeQuery(sql); 
                    if(rs.next()) { 
                    %>
                    <h3 style="color: green;">✅ 连接成功</h3>
                    <p>当前图书总数: <%= rs.getInt(1) %></p>
                    <p>连接对象: <%= conn.getClass().getName() %>
                    </p>
                    <% 
                } 
            } catch (Exception e) { 
                        %>
                        <h3 style="color: red;">❌ 连接失败</h3>
                        <p>错误信息: <%= e.getMessage() %>
                        </p>
                        <pre><%= e.toString() %></pre>
                        <% } finally { DBUtil.closeAll(conn, stmt, rs); } %>
            </body>

            </html>