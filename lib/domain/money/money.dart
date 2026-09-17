final class Money {
  const Money({required this.minorUnits, required this.currency});

  final int minorUnits;
  final String currency;

  double get majorUnits => minorUnits / 100;

  @override
  String toString() => '${majorUnits.toStringAsFixed(2)} $currency';
}

final class Txn {
  const Txn({
    required this.id,
    required this.description,
    required this.amount,
    required this.postedAt,
  });

  final String id;
  final String description;
  final Money amount;
  final DateTime postedAt;
}

final class TxnFilter {
  const TxnFilter({this.limit = 10});
  final int limit;
}
