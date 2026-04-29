import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class CheckHash {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String[] testPasswords = {"1235", "12345", "password", "123", "0000"};
        String storedHash = "$2a$10$m7Xq8Y5k3tH9vNnBrkS2UuXyZ4wQdVbAjRnOgPeCErL9QqKm5wX7m";

        System.out.println("Stored hash: " + storedHash);
        System.out.println();

        for (String pwd : testPasswords) {
            boolean matches = encoder.matches(pwd, storedHash);
            System.out.println("Password '" + pwd + "' matches: " + matches);
        }

        // Also show a newly generated hash for '1235'
        System.out.println("\nNew BCrypt hash for '1235':");
        System.out.println(encoder.encode("1235"));
    }
}
