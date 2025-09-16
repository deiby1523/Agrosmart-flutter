class Validators {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es requerido';
    }

    final trimmed = value.trim();

    if (trimmed.length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }

    if (trimmed.length > 30) {
      return 'El nombre no puede tener más de 30 caracteres';
    }

    // No permitir dígitos
    if (RegExp(r'[0-9]').hasMatch(trimmed)) {
      return 'El nombre no puede contener números';
    }

    // Permitir letras (incluye acentos y ñ), espacios, guiones y apóstrofes
    if (!RegExp(r"^[A-Za-zÁÉÍÓÚáéíóúÑñüÜ' -]+$").hasMatch(trimmed)) {
      return 'Nombre no válido';
    }

    return null;
  }

  static String? dni(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El DNI es requerido';
    }

    final trimmed = value.trim();

    // Solo permitir dígitos
    if (!RegExp(r'^[0-9]+$').hasMatch(trimmed)) {
      return 'El DNI solo debe contener números';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email es requerido';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email no válido';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contraseña es requerida';
    }
    if (value.length < 6) {
      return 'Contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirmar contraseña es requerido';
    }
    if (value != originalPassword) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  static String? breedDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    } else {
      final trimmed = value.trim();

      if (trimmed.length < 3) {
        return 'La descripción debe tener al menos 3 caracteres';
      }

      if (trimmed.length > 200) {
        return 'La descripción no puede tener más de 200 caracteres';
      }

      return null;
    }
  }
}
