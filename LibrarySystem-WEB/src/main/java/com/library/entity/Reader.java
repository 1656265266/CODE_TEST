package com.library.entity;

import java.sql.Timestamp; // 用于处理解冻日期

public class Reader {
    private int readerId;
    private String username;
    private String password;
    private String name;
    private String phone;
    private int borrowedCount;
    private String status; // "正常", "冻结", "已注销"
    private Timestamp unfreezeDate; // 解冻日期

    public Reader() {
    }

    // 这里只提供关键字段的构造，完整 Setter/Getter 如下
    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public int getBorrowedCount() {
        return borrowedCount;
    }

    public void setBorrowedCount(int borrowedCount) {
        this.borrowedCount = borrowedCount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getUnfreezeDate() {
        return unfreezeDate;
    }

    public void setUnfreezeDate(Timestamp unfreezeDate) {
        this.unfreezeDate = unfreezeDate;
    }
}