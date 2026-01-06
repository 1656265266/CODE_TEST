package com.library.dao;

import com.library.entity.Book;
import com.library.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

    private Book mapRowToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setIsbn(rs.getString("ISBN"));
        book.setBookName(rs.getString("BookName"));
        book.setAuthor(rs.getString("Author"));
        book.setPublisher(rs.getString("Publisher"));
        book.setCategory(rs.getString("Category"));
        book.setTotalStock(rs.getInt("TotalStock"));
        book.setCurrentStock(rs.getInt("CurrentStock"));

        String img = rs.getString("CoverImage");
        if (img == null || img.trim().isEmpty()) {
            book.setCoverImage("images/default_book.jpg");
        } else {
            book.setCoverImage(img);
        }
        return book;
    }

    public List<String[]> searchBorrowRecords(String keyword) {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT * FROM View_BorrowHistory WHERE BookName LIKE ? OR ReaderName LIKE ? OR Username LIKE ? OR ISBN LIKE ? ORDER BY BorrowDate DESC";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String likeStr = "%" + keyword + "%";
            pstmt.setString(1, likeStr);
            pstmt.setString(2, likeStr);
            pstmt.setString(3, likeStr);
            pstmt.setString(4, likeStr);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String[] record = new String[6];
                    record[0] = rs.getString("ReaderName");
                    record[1] = rs.getString("Username");
                    record[2] = rs.getString("BookName");
                    record[3] = rs.getString("ISBN");
                    record[4] = rs.getString("BorrowDate");
                    Timestamp returnDate = rs.getTimestamp("ReturnDate");
                    record[5] = (returnDate == null) ? "未归还" : returnDate.toString();
                    list.add(record);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Book> getAllBooks() {
        return getBooksByPage(null, null, 1, 10000);
    }

    public List<Book> searchBooks(String category, String keyword) {
        return getBooksByPage(category, keyword, 1, 10000);
    }

    public List<Book> getBooksByPage(String category, String keyword, int page, int pageSize) {
        List<Book> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Books WHERE IsActive = 1");
        List<Object> params = new ArrayList<>();

        if (category != null && !category.trim().isEmpty() && !"全部".equals(category)) {
            sql.append(" AND Category = ?");
            params.add(category);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (BookName LIKE ? OR Author LIKE ? OR Publisher LIKE ?)");
            String likeStr = "%" + keyword + "%";
            params.add(likeStr);
            params.add(likeStr);
            params.add(likeStr);
        }

        sql.append(" ORDER BY ISBN OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToBook(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getBookCount(String category, String keyword) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Books WHERE IsActive = 1");
        List<Object> params = new ArrayList<>();

        if (category != null && !category.trim().isEmpty() && !"全部".equals(category)) {
            sql.append(" AND Category = ?");
            params.add(category);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (BookName LIKE ? OR Author LIKE ? OR Publisher LIKE ?)");
            String likeStr = "%" + keyword + "%";
            params.add(likeStr);
            params.add(likeStr);
            params.add(likeStr);
        }

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public boolean addBook(Book book) {
        boolean success = false;
        try (Connection conn = DBUtil.getConnection()) {
            String checkSql = "SELECT TotalStock FROM Books WHERE ISBN = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, book.getIsbn());
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        String updateSql = "UPDATE Books SET TotalStock = TotalStock + ?, CurrentStock = CurrentStock + ?, IsActive = 1, Category = ?, CoverImage = ? WHERE ISBN = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setInt(1, book.getTotalStock());
                            updateStmt.setInt(2, book.getTotalStock());
                            updateStmt.setString(3, book.getCategory());
                            updateStmt.setString(4, book.getCoverImage());
                            updateStmt.setString(5, book.getIsbn());
                            success = updateStmt.executeUpdate() > 0;
                        }
                    } else {
                        String insertSql = "INSERT INTO Books (ISBN, BookName, Author, Publisher, Category, TotalStock, CurrentStock, IsActive, CoverImage) VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?)";
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                            insertStmt.setString(1, book.getIsbn());
                            insertStmt.setString(2, book.getBookName());
                            insertStmt.setString(3, book.getAuthor());
                            insertStmt.setString(4, book.getPublisher());
                            insertStmt.setString(5, book.getCategory());
                            insertStmt.setInt(6, book.getTotalStock());
                            insertStmt.setInt(7, book.getTotalStock());
                            insertStmt.setString(8, book.getCoverImage());
                            success = insertStmt.executeUpdate() > 0;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean deleteBook(String isbn) {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement("UPDATE Books SET IsActive = 0 WHERE ISBN = ?")) {
            pstmt.setString(1, isbn);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasActiveBorrows(String isbn) {
        boolean hasBorrows = false;
        String sql = "SELECT 1 FROM BorrowRecords WHERE ISBN = ? AND ReturnDate IS NULL";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, isbn);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next())
                    hasBorrows = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hasBorrows;
    }

    public String borrowBook(String isbn, int readerId) {
        String resultMsg = "系统繁忙";
        try (Connection conn = DBUtil.getConnection()) {

            // 1. 检查是否重复借阅同一本书
            String checkDup = "SELECT COUNT(*) FROM BorrowRecords WHERE ReaderID = ? AND ISBN = ? AND ReturnDate IS NULL";
            try (PreparedStatement ps = conn.prepareStatement(checkDup)) {
                ps.setInt(1, readerId);
                ps.setString(2, isbn);
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    return "您已借阅该书且未归还，不可重复借阅";
                }
            }

            // 2. 检查借阅数量限制 (限1本)
            String checkLimit = "SELECT COUNT(*) FROM BorrowRecords WHERE ReaderID = ? AND ReturnDate IS NULL";
            try (PreparedStatement ps = conn.prepareStatement(checkLimit)) {
                ps.setInt(1, readerId);
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) >= 5) {
                    return "借阅失败：您最多只能借阅 5 本书";
                }
            }

            // 3. 检查库存
            String checkStock = "SELECT CurrentStock FROM Books WHERE ISBN = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkStock)) {
                ps.setString(1, isbn);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int stock = rs.getInt(1);
                    if (stock <= 0)
                        return "库存不足";
                } else {
                    return "查无此书";
                }
            }

            // 4. 扣减库存
            String updateStock = "UPDATE Books SET CurrentStock = CurrentStock - 1 WHERE ISBN = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateStock)) {
                ps.setString(1, isbn);
                ps.executeUpdate();
            }

            // 5. 插入借阅记录
            String insertRecord = "INSERT INTO BorrowRecords (ISBN, ReaderID, BorrowDate) VALUES (?, ?, GETDATE())";
            try (PreparedStatement ps = conn.prepareStatement(insertRecord)) {
                ps.setString(1, isbn);
                ps.setInt(2, readerId);
                ps.executeUpdate();
            }

            return "Success";

        } catch (SQLException e) {
            e.printStackTrace();
            resultMsg = "数据库错误：" + e.getMessage();
        }
        return resultMsg;
    }

    public List<Book> getMyBorrowedBooks(int readerId) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.* FROM BorrowRecords br JOIN Books b ON br.ISBN = b.ISBN WHERE br.ReaderID = ? AND br.ReturnDate IS NULL";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, readerId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Book b = mapRowToBook(rs);
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public String returnBook(String isbn, int readerId) {
        String resultMsg = "归还失败";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        int maxDays = 30;
        double dailyFine = 1.0;

        try {
            conn = DBUtil.getConnection();

            String querySql = "SELECT RecordID, DATEDIFF(day, BorrowDate, GETDATE()) as DiffDays FROM BorrowRecords WHERE ReaderID = ? AND ISBN = ? AND ReturnDate IS NULL";
            pstmt = conn.prepareStatement(querySql);
            pstmt.setInt(1, readerId);
            pstmt.setString(2, isbn);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int recordId = rs.getInt("RecordID");
                int diffDays = rs.getInt("DiffDays");
                pstmt.close();

                if (diffDays > maxDays) {
                    int overdueDays = diffDays - maxDays;
                    double fineAmount = overdueDays * dailyFine;

                    String fineSql = "INSERT INTO Fines (ReaderID, ISBN, Amount, GeneratedDate, Status) VALUES (?, ?, ?, GETDATE(), '未缴纳')";
                    pstmt = conn.prepareStatement(fineSql);
                    pstmt.setInt(1, readerId);
                    pstmt.setString(2, isbn);
                    pstmt.setBigDecimal(3, new java.math.BigDecimal(fineAmount));
                    pstmt.executeUpdate();
                    pstmt.close();

                    resultMsg = "归还成功，但已逾期 " + overdueDays + " 天，产生罚款 " + fineAmount + " 元！";
                } else {
                    resultMsg = "归还成功！";
                }

                String updateRecordSql = "UPDATE BorrowRecords SET ReturnDate = GETDATE() WHERE RecordID = ?";
                pstmt = conn.prepareStatement(updateRecordSql);
                pstmt.setInt(1, recordId);
                pstmt.executeUpdate();
                pstmt.close();

                String updateStockSql = "UPDATE Books SET CurrentStock = CurrentStock + 1 WHERE ISBN = ?";
                pstmt = conn.prepareStatement(updateStockSql);
                pstmt.setString(1, isbn);
                pstmt.executeUpdate();
            } else {
                resultMsg = "未找到该书的在借记录，无法归还。";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resultMsg = "系统错误：" + e.getMessage();
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
        return resultMsg;
    }

    public List<String[]> getAllBorrowRecords() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT * FROM View_BorrowHistory ORDER BY BorrowDate DESC";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                String[] record = new String[6];
                record[0] = rs.getString("ReaderName");
                record[1] = rs.getString("Username");
                record[2] = rs.getString("BookName");
                record[3] = rs.getString("ISBN");
                record[4] = rs.getString("BorrowDate");
                Timestamp returnDate = rs.getTimestamp("ReturnDate");
                record[5] = (returnDate == null) ? "未归还" : returnDate.toString();
                list.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int[] getLibraryStats() {
        int[] stats = { 0, 0, 0 };
        try (Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt
                        .executeQuery("SELECT SUM(TotalStock), SUM(CurrentStock) FROM Books WHERE IsActive = 1")) {
            if (rs.next()) {
                stats[0] = rs.getInt(1);
                stats[1] = rs.getInt(2);
                stats[2] = stats[0] - stats[1];
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
}