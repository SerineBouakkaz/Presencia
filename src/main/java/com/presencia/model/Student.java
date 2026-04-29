package com.presencia.model;

public class Student {
    private Long id;
    private String firstName;
    private String lastName;
    private String studentCode;
    private String department;
    private String email;
    private String phone;
    private String groupName;

    public Student() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getStudentCode() { return studentCode; }
    public void setStudentCode(String studentCode) { this.studentCode = studentCode; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }

    public String getFullName() { return firstName + " " + lastName; }

    public String getInitials() {
        String f = firstName != null && !firstName.isEmpty() ? firstName.substring(0, 1) : "";
        String l = lastName != null && !lastName.isEmpty() ? lastName.substring(0, 1) : "";
        return (f + l).toUpperCase();
    }

    public int getAttendancePercentage() { return attendancePercentage; }
    public void setAttendancePercentage(int attendancePercentage) { this.attendancePercentage = attendancePercentage; }
    public int getTotalDays() { return totalDays; }
    public void setTotalDays(int totalDays) { this.totalDays = totalDays; }
    public int getPresentDays() { return presentDays; }
    public void setPresentDays(int presentDays) { this.presentDays = presentDays; }

    private int attendancePercentage = 90;
    private int totalDays = 18;
    private int presentDays = 16;
}
