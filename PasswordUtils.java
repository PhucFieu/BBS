package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtils {
    
    /**
     * Hash password using MD5 and convert to uppercase
     * @param password the plain text password
     * @return MD5 hash in uppercase
     */
    public static String hashPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return null;
        }
        
        try {
            // Create MD5 hash
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hashBytes = md.digest(password.getBytes());
            
            // Convert to hexadecimal string
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            
            // Convert to uppercase
            return hexString.toString().toUpperCase();
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5 algorithm not available", e);
        }
    }
    
    /**
     * Verify password by comparing with hashed password
     * @param plainPassword the plain text password to verify
     * @param hashedPassword the stored hashed password
     * @return true if passwords match, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        
        String hashedInput = hashPassword(plainPassword);
        return hashedInput.equals(hashedPassword);
    }
    
    /**
     * Test method to generate MD5 hashes for existing passwords
     * This method is for testing purposes only
     */
    public static void main(String[] args) {
        System.out.println("admin123 -> " + hashPassword("admin123"));
        System.out.println("staff123 -> " + hashPassword("staff123"));
        System.out.println("customer123 -> " + hashPassword("customer123"));
    }
} 