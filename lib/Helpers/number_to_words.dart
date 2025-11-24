// number_to_words.dart

String numberToWords(int number) {
  if (number == 0) return 'zero';

  if (number < 0) return 'minus ${_convertNumber(-number)}';
  return _convertNumber(number);
}

String _convertNumber(int n) {
  final units = [
    '',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen'
  ];

  final tens = [
    '',
    '',
    'Twenty',
    'Thirty',
    'Forty',
    'Fifty',
    'Sixty',
    'Seventy',
    'Eighty',
    'Ninety'
  ];

  String threeDigitsToWords(int num) {
    String res = '';
    if (num >= 100) {
      int h = num ~/ 100;
      res += '${units[h]} Hundred';
      num = num % 100;
      if (num > 0) res += ' ';
    }
    if (num >= 20) {
      int t = num ~/ 10;
      res += tens[t];
      int u = num % 10;
      if (u > 0) res += ' ${units[u]}';
    } else if (num > 0) {
      res += units[num];
    }
    return res;
  }

  final parts = <String>[];
  final scales = ['','Thousand','Million','Billion','Trillion'];

  int scaleIndex = 0;
  while (n > 0) {
    int chunk = n % 1000;
    if (chunk != 0) {
      String chunkWords = threeDigitsToWords(chunk);
      if (scales[scaleIndex].isNotEmpty) {
        chunkWords = '$chunkWords ${scales[scaleIndex]}';
      }
      parts.insert(0, chunkWords); // prepend
    }
    n = n ~/ 1000;
    scaleIndex++;
    if (scaleIndex >= scales.length && n > 0) {
      // number too large for defined scales
      throw ArgumentError('Number too large');
    }
  }

  return parts.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
}
