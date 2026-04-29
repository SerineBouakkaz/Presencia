package com.presencia.model;

public class Professor {
    private Long id;
    private String name;
    private String email;
    private String password;
    private String department;
    private String role; // "professor" or "admin"
    private boolean forcePasswordChange = false;

    public Professor() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isForcePasswordChange() { return forcePasswordChange; }
    public void setForcePasswordChange(boolean forcePasswordChange) { this.forcePasswordChange = forcePasswordChange; }

    public boolean isAdmin() { return "admin".equalsIgnoreCase(role); }

    public String getInitials() {
        if (name == null || name.isEmpty()) return "?";
        String[] parts = name.split("\\s+");
        StringBuilder sb = new StringBuilder();
        for (String p : parts) {
            if (!p.isEmpty()) sb.append(p.charAt(0));
        }
        return sb.length() > 2 ? sb.substring(0, 2) : sb.toString();
    }
}
