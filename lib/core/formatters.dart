String formatMoney(num value) {
  final number = value.round().toString();

  final buffer = StringBuffer();

  for (int i = 0; i < number.length; i++) {
    final positionFromRight =
        number.length - i;

    buffer.write(number[i]);

    if (positionFromRight > 1 &&
        (positionFromRight - 1) % 3 == 0) {
      buffer.write('.');
    }
  }

  return '${buffer.toString()}đ';
}