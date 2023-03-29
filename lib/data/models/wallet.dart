import 'package:intl/intl.dart';

class Wallet {
  final String coinType;
  final int amount;

  Wallet({required this.coinType, required this.amount});

  String get balance {
    final formatter = NumberFormat();
    return amount > 0 ? formatter.format(amount) : "0";
  }

  Map<String, dynamic> toJson() => {'coinType': coinType, 'amount': amount};

  factory Wallet.fromJson(Map<String, dynamic> value) {
    return Wallet(
      coinType: value['coinType'],
      amount: value['amount'],
    );
  }

  Wallet copyWith({String? coinType, int? amount}) {
    return Wallet(coinType: coinType ?? this.coinType, amount: amount ?? this.amount);
  }

  @override
  String toString() {
    return 'Wallet{coinType: $coinType, amount: $amount}';
  }
}
