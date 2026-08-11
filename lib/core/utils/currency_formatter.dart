String formatCurrency(double amount) {
  final parts = amount.toStringAsFixed(2).split('.');
  final digits = parts[0];
  final grouped = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      grouped.write(',');
    }
    grouped.write(digits[i]);
  }
  return 'RM ${grouped.toString()}.${parts[1]}';
}
