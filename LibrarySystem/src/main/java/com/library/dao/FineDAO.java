package com.library.dao;

import com.library.entity.Fine;
import com.library.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FineDAO {

    // 查询某位读者的所有罚单
    public List<Fine> getFinesByReader(int readerId) {
        List<Fine> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM Fines WHERE ReaderID = ? ORDER BY Status DESC, GeneratedDate DESC";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, readerId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Fine f = new Fine();
                f.setFineId(rs.getInt("FineID"));
                f.setReaderId(rs.getInt("ReaderID"));
                f.setAmount(rs.getDouble("Amount"));
                f.setReason(rs.getString("Reason"));
                f.setStatus(rs.getString("Status"));
                f.setGeneratedDate(rs.getDate("GeneratedDate"));
                list.add(f);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 缴纳罚款
    public boolean payFine(int fineId) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "UPDATE Fines SET Status = '已缴纳', PayDate = GETDATE() WHERE FineID = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, fineId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 查询该读者是否有未缴纳的罚款
    public boolean hasUnpaidFines(int readerId) {
        boolean hasFines = false;
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT COUNT(*) FROM Fines WHERE ReaderID = ? AND Status = '未缴纳'";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, readerId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                hasFines = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hasFines;
    }
}