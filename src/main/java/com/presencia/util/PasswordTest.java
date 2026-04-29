package com.presencia.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordTest {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        if (args.length > 0) {
            // Generate hash for provided password
            String plainPassword = args[0];
            String hash = encoder.encode(plainPassword);
            System.out.println("Password: " + plainPassword);
            System.out.println("BCrypt Hash: " + hash);
        } else {
            // Test mode: verify known hash
            String plainPassword = "password";
            String storedHash = "$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7GAt6KUau";

            boolean matches = encoder.matches(plainPassword, storedHash);
            System.out.println("Password 'password' matches stored hash: " + matches);

            String generatedHash = encoder.encode(plainPassword);
            System.out.println("Generated hash for 'password': " + generatedHash);
        }
    }
}