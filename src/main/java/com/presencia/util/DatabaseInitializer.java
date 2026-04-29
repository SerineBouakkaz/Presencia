package com.presencia.util;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.BufferedReader;
import java.io.FileReader;

@Component
public class DatabaseInitializer {

    private final JdbcTemplate jdbcTemplate;

    public DatabaseInitializer(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @PostConstruct
    public void initializeDatabase() {
        try {
            // Run L2 students import
            executeSqlScript("C:/Users/raf/.claude/projects/C--Users-raf--claude/presencia/src/main/resources/db/import_l2_students.sql");

            // Run professor department update
            executeSqlScript("C:/Users/raf/.claude/projects/C--Users-raf--claude/presencia/src/main/resources/db/update_professor_department.sql");

            System.out.println("Database initialization completed!");
        } catch (Exception e) {
            System.err.println("Error initializing database: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void executeSqlScript(String filePath) throws Exception {
        System.out.println("Executing SQL script: " + filePath);

        BufferedReader reader = new BufferedReader(new FileReader(filePath));
        StringBuilder sql = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            // Skip comments and empty lines
            if (!line.trim().startsWith("--") && !line.trim().isEmpty()) {
                sql.append(line).append("\n");
            }
        }
        reader.close();

        // Split into individual statements
        String[] statements = sql.toString().split(";");

        // Execute each statement
        for (String statement : statements) {
            if (!statement.trim().isEmpty()) {
                jdbcTemplate.execute(statement.trim() + ";");
            }
        }

        System.out.println("Completed: " + filePath);
    }
}