extension CurrencyFormatter on String {
  String toCurrencyFormat() {
    // حذف تمام کاراکترهای غیر عددی
    String cleaned = replaceAll(RegExp(r'[^0-9]'), '');

    // تبدیل به عدد
    if (cleaned.isEmpty) return '0';

    int number = int.parse(cleaned);

    // فرمت کردن به صورت سه رقم سه رقم
    String formatted = number.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
        );

    return formatted;
  }
}
