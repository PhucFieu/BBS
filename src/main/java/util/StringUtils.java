package util;

/**
 * Utility class for string manipulation
 */
public class StringUtils {

    /**
     * Normalizes a string by:
     * 1. Trimming leading and trailing whitespace
     * 2. Collapsing multiple consecutive spaces into a single space
     * 
     * This is useful for preventing duplicates where names differ only by extra spaces.
     * 
     * @param input the string to normalize
     * @return normalized string, or null if input is null
     */
    public static String normalizeSpaces(String input) {
        if (input == null) {
            return null;
        }
        // Trim leading/trailing whitespace, then collapse multiple spaces to single space
        return input.trim().replaceAll("\\s+", " ");
    }

    /**
     * Checks if a string is null or empty after trimming
     * 
     * @param input the string to check
     * @return true if null or empty/whitespace only
     */
    public static boolean isBlank(String input) {
        return input == null || input.trim().isEmpty();
    }

    /**
     * Checks if a string is not null and not empty after trimming
     * 
     * @param input the string to check
     * @return true if not null and has content after trimming
     */
    public static boolean isNotBlank(String input) {
        return !isBlank(input);
    }
}

