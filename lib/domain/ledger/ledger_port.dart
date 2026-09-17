import 'package:hg_flutter/domain/money/money.dart';

abstract class LedgerPort {
  Future<Money> availableBalance(String accountId);
  Future<List<Txn>> transactions(TxnFilter filter);
}
