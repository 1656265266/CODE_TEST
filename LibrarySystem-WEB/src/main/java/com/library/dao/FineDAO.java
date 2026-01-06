package com.library.dao;

import com.library.entity.Fine;
import com.library.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FineDAO {

    public List<Fine> getFinesByReaderId(int readerId) {
        List<Fine> list = new ArrayList<>();
        String sql = "SELECT * FROM Fines WHERE ReaderID = ? ORDER BY GeneratedDate DESC";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, readerId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Fine f = new Fine();
                    f.setFineId(rs.getInt("FineID"));
                    f.setReaderId(rs.getInt("ReaderID"));
                    f.setIsbn(rs.getString("ISBN"));
                    f.setAmount(rs.getBigDecimal("Amount"));
                    f.setGeneratedDate(rs.getTimestamp("GeneratedDate"));
                    f.setStatus(rs.getString("Status"));
                    list.add(f);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean payFine(int fineId) {
        boolean success = false;
        String sql = "UPDATE Fines SET Status = '已缴纳', PayDate = GETDATE() WHERE FineID = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, fineId);
            success = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public void addFine(int readerId, String isbn, double amount) {
        String sql = "INSERT INTO Fines (ReaderID, ISBN, Amount, GeneratedDate, Status) VALUES (?, ?, ?, GETDATE(), '未缴纳')";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, readerId);
            pstmt.setString(2, isbn);
            pstmt.setBigDecimal(3, new java.math.BigDecimal(amount));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}