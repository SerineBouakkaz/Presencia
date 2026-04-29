import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class TestBCrypt {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String password = "1235";
        String storedHash = "$2b$10$LCEbpiosmdiVlL3/Ex4o.uu.ASF4asMpQGeX.kx0WCqq4JOqE.7My";

        boolean matches = encoder.matches(password, storedHash);
        System.out.println("Password: " + password);
        System.out.println("Stored hash: " + storedHash);
        System.out.println("Matches using Spring BCrypt: " + matches);
    }
}
