package util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Utility class for handling URL encoding, especially for Vietnamese characters
 */
public class URLUtils {
    
    /**
     * URL encodes a string using UTF-8 encoding
     * @param value the string to encode
     * @return the URL encoded string
     */
    public static String encode(String value) {
        if (value == null) {
            return "";
        }
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
    
    /**
     * Creates a URL parameter string with proper encoding
     * @param paramName the parameter name
     * @param paramValue the parameter value
     * @return the encoded parameter string (e.g., "error=encoded_value")
     */
    public static String createParameter(String paramName, String paramValue) {
        return paramName + "=" + encode(paramValue);
    }
} 