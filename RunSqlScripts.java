import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class RunSqlScripts {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/presencia_db?useSSL=false&serverTimezone=UTC";
        String username = "root";
        String password = "your_password"; // Change this to your MySQL password

        try (Connection conn = DriverManager.getConnection(url, username, password)) {
            System.out.println("Connected to database successfully!");

            // Run import script
            runSqlScript(conn, "C:/Users/raf/.claude/projects/C--Users-raf--claude/presencia/src/main/resources/db/import_l2_students.sql");

            // Run update script
            runSqlScript(conn, "C:/Users/raf/.claude/projects/C--Users-raf--claude/presencia/src/main/resources/db/update_professor_department.sql");

            System.out.println("SQL scripts executed successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void runSqlScript(Connection conn, String filePath) throws Exception {
        System.out.println("Executing: " + filePath);

        // Read SQL file
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
        try (Statement stmt = conn.createStatement()) {
            for (String statement : statements) {
                if (!statement.trim().isEmpty()) {
                    stmt.execute(statement.trim() + ";");
                }
            }
        }

        System.out.println("Completed: " + filePath);
    }
}