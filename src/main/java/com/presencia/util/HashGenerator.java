package com.presencia.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class HashGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String hash = encoder.encode("password");
        System.out.println("BCRYPT_HASH=" + hash);

        // Verify it works
        System.out.println("MATCHES=" + encoder.matches("password", hash));

        // Verify against known-good hash for "password"
        String knownHash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";
        System.out.println("KNOWN_MATCHES=" + encoder.matches("password", knownHash));
    }
}
