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
        return book;
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
                        String updateSql = "UPDATE Books SET TotalStock = TotalStock + ?, CurrentStock = CurrentStock + ?, IsActive = 1, Category = ? WHERE ISBN = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setInt(1, book.getTotalStock());
                            updateStmt.setInt(2, book.getTotalStock());
                            updateStmt.setString(3, book.getCategory());
                            updateStmt.setString(4, book.getIsbn());
                            success = updateStmt.executeUpdate() > 0;
                        }
                    } else {
                        String insertSql = "INSERT INTO Books (ISBN, BookName, Author, Publisher, Category, TotalStock, CurrentStock, IsActive) VALUES (?, ?, ?, ?, ?, ?, ?, 1)";
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                            insertStmt.setString(1, book.getIsbn());
                            insertStmt.setString(2, book.getBookName());
                            insertStmt.setString(3, book.getAuthor());
                            insertStmt.setString(4, book.getPublisher());
                            insertStmt.setString(5, book.getCategory());
                            insertStmt.setInt(6, book.getTotalStock());
                            insertStmt.setInt(7, book.getTotalStock());
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
        String resultMsg = "系统繁忙，请稍后重试";
        String sql = "{call sp_BorrowBook(?, ?, ?, ?)}";

        try (Connection conn = DBUtil.getConnection();
                CallableStatement cstmt = conn.prepareCall(sql)) {

            cstmt.setString(1, isbn);
            cstmt.setInt(2, readerId);
            cstmt.registerOutParameter(3, Types.BIT);
            cstmt.registerOutParameter(4, Types.NVARCHAR);

            cstmt.execute();

            boolean isSuccess = cstmt.getBoolean(3);
            String dbMsg = cstmt.getString(4);

            if (isSuccess) {
                resultMsg = "Success";
            } else {
                resultMsg = dbMsg;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            resultMsg = "数据库连接异常";
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
                    Book b = new Book();
                    b.setIsbn(rs.getString("ISBN"));
                    b.setBookName(rs.getString("BookName"));
                    b.setAuthor(rs.getString("Author"));
                    b.setPublisher(rs.getString("Publisher"));
                    b.setCategory(rs.getString("Category"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean returnBook(String isbn, int readerId) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String querySql = "SELECT TOP 1 RecordID FROM BorrowRecords WHERE ReaderID = ? AND ISBN = ? AND ReturnDate IS NULL ORDER BY BorrowDate ASC";
            pstmt = conn.prepareStatement(querySql);
            pstmt.setInt(1, readerId);
            pstmt.setString(2, isbn);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int recordId = rs.getInt("RecordID");
                pstmt.close();
                String updateSql = "UPDATE BorrowRecords SET ReturnDate = GETDATE() WHERE RecordID = ?";
                pstmt = conn.prepareStatement(updateSql);
                pstmt.setInt(1, recordId);
                success = pstmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
        return success;
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