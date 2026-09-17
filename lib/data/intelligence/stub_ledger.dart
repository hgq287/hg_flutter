import 'package:hg_flutter/domain/ledger/ledger_port.dart';
import 'package:hg_flutter/domain/money/money.dart';

final class StubLedger implements LedgerPort {
  const StubLedger();

  static const Money _balance = Money(minorUnits: 125000, currency: 'USD');

  @override
  Future<Money> availableBalance(String accountId) async => _balance;

  @override
  Future<List<Txn>> transactions(TxnFilter filter) async {
    return [
      Txn(
        id: 'txn-1001',
        description: 'Grocery',
        amount: const Money(minorUnits: -2450, currency: 'USD'),
        postedAt: DateTime.utc(2026, 9, 1),
      ),
      Txn(
        id: 'txn-1002',
        description: 'Payroll',
        amount: const Money(minorUnits: 250000, currency: 'USD'),
        postedAt: DateTime.utc(2026, 9, 5),
      ),
    ].take(filter.limit).toList();
  }
}
