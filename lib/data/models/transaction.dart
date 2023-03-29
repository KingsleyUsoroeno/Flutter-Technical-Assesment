import 'package:flutter_crypto_wallet/data/models/coin_type.dart';
import 'package:intl/intl.dart';

class Transaction {
  final CoinType coinType;
  final String customerName;
  final String countryOfOrigin;
  final int amount;
  final bool isSuccessful;

  Transaction({
    required this.coinType,
    required this.customerName,
    required this.countryOfOrigin,
    required this.amount,
    required this.isSuccessful,
  });

  String get transAmount {
    final formatter = NumberFormat();
    return amount > 0 ? formatter.format(amount) : "0";
  }

  Map<String, dynamic> toJson() {
    return {
      'coinType': coinType.name,
      'customerName': customerName,
      'countryOfOrigin': countryOfOrigin,
      'amount': amount,
      'isSuccessful': isSuccessful,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> value) {
    return Transaction(
      coinType: CoinType.values.firstWhere((element) => element.name == value['coinType']),
      amount: value['amount'],
      customerName: value['customerName'],
      countryOfOrigin: value['countryOfOrigin'],
      isSuccessful: value['isSuccessful'],
    );
  }

  @override
  String toString() {
    return 'Transaction{coinType: $coinType, customerName: $customerName, '
        'countryOfOrigin: $countryOfOrigin, amount: $amount, isSuccessful: $isSuccessful}';
  }
}
