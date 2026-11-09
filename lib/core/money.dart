/// Formats an amount into Egyptian Pounds (EGP).
/// Accepts [num], [double], [int], or [String] with numbers.
/// Never outputs dollar signs.
String egp(dynamic amount) {
  if (amount == null) return 'EGP 0';

  num value = 0;
  if (amount is num) {
    value = amount;
  } else if (amount is String) {
    final cleaned = amount.replaceAll(RegExp(r'[^0-9.]'), '');
    value = num.tryParse(cleaned) ?? 0;
  }

  if (value % 1 == 0) {
    return 'EGP ${value.toInt()}';
  }
  return 'EGP ${value.toStringAsFixed(2)}';
}

/// Parses any currency string or number to double
double parsePrice(dynamic amount) {
  if (amount == null) return 0.0;
  if (amount is num) return amount.toDouble();
  final cleaned = amount.toString().replaceAll(RegExp(r'[^0-9.]'), '');
  return double.tryParse(cleaned) ?? 0.0;
}

