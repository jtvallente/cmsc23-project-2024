bool isPasswordValid(String password) {
  return password.length >= 8;
}

String? _validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  return null;
}

String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email';
  }
  // Regular expression for validating an email
  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

String? _validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a username';
  }
  return null;
}

String? _validatePassword(String? value) {
  if (value == null || value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  return null;
}

String? _validateAddress(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an address';
  }
  return null;
}

String? _validateContactNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a contact number';
  } else if (num.tryParse(value) == null) {
    return 'Contact number should be a number';
  }
  return null;
}
