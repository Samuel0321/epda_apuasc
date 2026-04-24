package utils;

public final class PasswordValidator {

    public static final String REQUIREMENTS_MESSAGE =
            "Password must be at least 8 characters and include uppercase, lowercase, number, and special character.";

    private PasswordValidator() {
    }

    public static boolean isStrong(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }

        boolean hasUppercase = false;
        boolean hasLowercase = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;

        for (int i = 0; i < password.length(); i++) {
            char value = password.charAt(i);
            if (Character.isUpperCase(value)) {
                hasUppercase = true;
            } else if (Character.isLowerCase(value)) {
                hasLowercase = true;
            } else if (Character.isDigit(value)) {
                hasDigit = true;
            } else if (!Character.isWhitespace(value)) {
                hasSpecial = true;
            }
        }

        return hasUppercase && hasLowercase && hasDigit && hasSpecial;
    }
}
