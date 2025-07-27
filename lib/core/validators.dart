class Validators {
  Validators._();
  static String? validateLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Login cannot be empty';
    }
    if (value.length < 3) {
      return 'Login must be at least 3 characters long';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? validateComment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Comment cannot be empty';
    }
    return null;
  }
}
