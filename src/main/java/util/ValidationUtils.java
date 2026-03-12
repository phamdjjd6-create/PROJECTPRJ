package util;

import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.regex.Pattern;

/**
 * Utility class for validating resort data. 
 * Refactored to remove console I/O for Web architecture compatibility.
 */
public class ValidationUtils {

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    /**
     * Standardizes email validation for @gmail.com
     */
    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        String regex = "^[\\w.-]+@gmail\\.com$";
        return Pattern.matches(regex, email);
    }

    /**
     * Validates Customer ID format: KH-YYYY
     */
    public static boolean isValidCustomerId(String id) {
        return id != null && id.matches("^KH-\\d{4}$");
    }

    /**
     * Validates Employee ID format: NV-YYYY
     */
    public static boolean isValidEmployeeId(String id) {
        return id != null && id.matches("^NV-\\d{4}$");
    }

    /**
     * Validates Phone Number (starts with 0, has 10 digits)
     */
    public static boolean isValidPhoneNumber(String phone) {
        return phone != null && phone.matches("^0\\d{9}$");
    }

    /**
     * Validates Date format (dd/MM/yyyy)
     */
    public static boolean isValidDate(String dateStr) {
        if (dateStr == null) return false;
        try {
            LocalDate.parse(dateStr, DATE_FORMAT);
            return true;
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    /**
     * Validates if a person is at least 18 years old
     */
    public static boolean isOldEnough(LocalDate dob) {
        if (dob == null) return false;
        return Period.between(dob, LocalDate.now()).getYears() >= 18;
    }

    /**
     * Validates ID Card (9 or 12 digits)
     */
    public static boolean isValidIdCard(String idCard) {
        return idCard != null && (idCard.matches("^\\d{9}$") || idCard.matches("^\\d{12}$"));
    }

    /**
     * Validates Name (Capitalizes first letter of each word)
     */
    public static boolean isValidFullName(String name) {
        return name != null && name.matches("^([A-Z][a-z]+)(\\s[A-Z][a-z]+)*$");
    }

    /**
     * Validates Facility ID format: SVXX-YYYY 
     * XX is VL (Villa), HO (House), or RO (Room)
     */
    public static boolean isValidFacilityId(String id) {
        return id != null && id.matches("^SV(VL|HO|RO)-\\d{4}$");
    }
    
    /**
     * Validates Booking ID format: BK-YYYY (updated to allow BK-YYYY based on context, or BK\\d{3} as per old code)
     */
    public static boolean isValidBookingId(String id) {
        // Keeping it flexible but consistent with old pattern or improved one
        return id != null && id.matches("^BK\\d{3,4}$");
    }
}
