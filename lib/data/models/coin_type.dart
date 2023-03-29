enum CoinType { usdt, usdc }

extension CoinTypeImage on CoinType {
  String get image {
    switch (this) {
      case CoinType.usdt:
        return "assets/images/usdt_logo.png";
      case CoinType.usdc:
        return "assets/images/usdc.png";
    }
  }
}
