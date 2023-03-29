import 'package:flutter/cupertino.dart';
import 'package:flutter_crypto_wallet/data/models/coin.dart';
import 'package:flutter_crypto_wallet/data/models/coin_type.dart';
import 'package:flutter_crypto_wallet/ui/screens/crypto_transfer/transfer_crypto_screen.dart';
import 'package:flutter_crypto_wallet/ui/screens/wallet/create_fund_wallet_screen.dart';
import 'package:flutter_crypto_wallet/ui/screens/home/home_screen.dart';

// since our application does not perform navigation from deep-links
// or anything relatively complex named-routes will do just fine

class AppRouter {
  AppRouter._();

  static const String homeRoute = '/home';
  static const String createWalletRoute = '/createWalletRoute';
  static const String cryptoTransferRoute = '/cryptoTransferRoute';

  static final Map<String, WidgetBuilder> routes = {
    homeRoute: (_) => const HomeScreen(),
    createWalletRoute: (context) => CreateFundWalletScreen(
          coin: ModalRoute.of(context)?.settings.arguments as Coin?,
        ),
    cryptoTransferRoute: (context) =>
        TransferCryptoScreen(coin: ModalRoute.of(context)?.settings.arguments as Coin),
  };
}
