package com.library.dao;

import com.library.entity.Admin;
import com.library.entity.Reader;
import com.library.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public Admin loginAdmin(String username, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Admin admin = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM Admins WHERE Username = ? AND Password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                admin = new Admin();
                admin.setAdminId(rs.getInt("AdminID"));
                admin.setUsername(rs.getString("Username"));
                admin.setName(rs.getString("Name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
        return admin;
    }

    public Reader loginReader(String username, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Reader reader = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM Readers WHERE Username = ? AND Password = ? AND Status != '已注销'";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                reader = new Reader();
                reader.setReaderId(rs.getInt("ReaderID"));
                reader.setUsername(rs.getString("Username"));
                reader.setName(rs.getString("Name"));
                reader.setStatus(rs.getString("Status"));
                reader.setBorrowedCount(rs.getInt("BorrowedCount"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
        return reader;
    }

    public Reader getReaderById(int readerId) {
        Reader reader = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM Readers WHERE ReaderID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, readerId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                reader = new Reader();
                reader.setReaderId(rs.getInt("ReaderID"));
                reader.setUsername(rs.getString("Username"));
                reader.setName(rs.getString("Name"));
                reader.setPhone(rs.getString("Phone"));
                reader.setBorrowedCount(rs.getInt("BorrowedCount"));
                reader.setStatus(rs.getString("Status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
        return reader;
    }

    public boolean updateReaderStatus(int readerId, String newStatus) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE Readers SET Status = ? WHERE ReaderID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, readerId);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                success = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, pstmt, null);
        }
        return success;
    }

    public void generateDueWarnings() {
        Connection conn = null;
        CallableStatement cstmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "{call sp_GenerateDueWarnings()}";
            cstmt = conn.prepareCall(sql);
            cstmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, cstmt, null);
        }
    }

    public List<String> getReaderNotifications(int readerId) {
        List<String> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT Message FROM Notifications WHERE ReaderID = ? ORDER BY CreatedAt DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, readerId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("Message"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
        return list;
    }
}