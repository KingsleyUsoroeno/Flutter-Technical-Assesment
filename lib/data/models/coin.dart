import 'package:flutter_crypto_wallet/data/models/coin_type.dart';
import 'package:intl/intl.dart';

class Coin {
  final String image;
  final String name;
  final CoinType coinType;
  final int availableBalance;

  Coin({
    required this.image,
    required this.name,
    required this.coinType,
    this.availableBalance = 0,
  });

  String get balance {
    final formatter = NumberFormat();
    return formatter.format(availableBalance);
  }

  Coin copyWith({
    String? image,
    String? name,
    CoinType? coinType,
    int? availableBalance,
  }) {
    return Coin(
      image: image ?? this.image,
      name: name ?? this.name,
      coinType: coinType ?? this.coinType,
      availableBalance: availableBalance ?? this.availableBalance,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Coin && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Coin{image: $image, name: $name, coinType: $coinType, availableBalance: $availableBalance}';
  }
}

final availableCoins = <Coin>[
  Coin(image: "assets/images/usdt_logo.png", name: "USDT", coinType: CoinType.usdt),
  Coin(image: "assets/images/usdc.png", name: "USDC", coinType: CoinType.usdc),
];
