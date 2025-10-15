
// utils/validators.dart

bool validateRequired(String value) => value.trim().isNotEmpty;

bool validateLetters(String value) => RegExp(r'^[a-zA-Z]+$').hasMatch(value);

bool validateNumbers(String value) => RegExp(r'^[0-9]+$').hasMatch(value);

bool validateLength(String value, int length) => value.length == length;

bool validateEmail(String value) =>
    RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(value);

bool validateZip(String value) => RegExp(r'^\d{5,6}$').hasMatch(value); // 5 o 6 dígitos

bool validateExpiration(String value) {
  try {
    // Acepta MM/yy o MM/yyyy (si user pega 02/2028 también funcionará parcialmente)
    final parts = value.split('/');
    if (parts.length != 2) return false;
    final month = int.parse(parts[0]);
    var year = int.parse(parts[1]);
    if (month < 1 || month > 12) return false;

    // si user puso 2 dígitos (ej 28), lo convertimos a 2028
    if (parts[1].length == 2) year += 2000;
    final now = DateTime.now();

    // Fecha de expiración la ponemos al primer día del mes siguiente para que
    // una tarjeta que expire en 02/28 sea válida hasta finales de febrero.
    final expDate = DateTime(year, month + 1, 1);
    return expDate.isAfter(now);
  } catch (_) {
    return false;
  }
}

bool validateCVV(String value) => RegExp(r'^\d{3}$').hasMatch(value);

bool validateCardNumber(String value) => RegExp(r'^\d{16}$').hasMatch(value);
