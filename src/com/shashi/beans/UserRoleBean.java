package com.shashi.beans;

public class UserRoleBean {

    public UserRoleBean() {
    }

    public UserRoleBean(String userEmail, int roleId) {
        this.userEmail = userEmail;
        this.roleId = roleId;
    }

    private String userEmail;
    private int roleId;

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }
}