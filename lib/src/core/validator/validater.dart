class MyValidator {
  static String? nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return "Name is required";
    }
    return null;
  }

  static String? emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    ).hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  }

  static String? passwrdValidator(String? paswword) {
    if (paswword == null || paswword.isEmpty) {
      return "paswword is requred";
    }
    if (paswword.length <= 5) {
      return "pleas enter a valid id 6 number ";
    }

    return null;
  }
}
