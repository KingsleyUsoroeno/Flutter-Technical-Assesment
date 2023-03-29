import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_crypto_wallet/data/models/coin_type.dart';
import 'package:flutter_crypto_wallet/data/models/transaction.dart';
import 'package:flutter_crypto_wallet/data/models/wallet.dart';
import 'package:flutter_crypto_wallet/data/services/shared_preference_service.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final SharedPreferenceService _preferenceService;

  HomeScreenCubit(this._preferenceService) : super(const HomeScreenState());

  void fetchData(CoinType coinType) async {
    emit(state.copyWith(isLoadingData: true));
    await Future.delayed(const Duration(milliseconds: 1000));
    final Wallet? wallet = await _preferenceService.getWallet(coinType);
    final transactions = await _preferenceService.getRecentTransactions();
    final username = _preferenceService.getUsername();
    emit(state.copyWith(
      wallet: wallet,
      isLoadingData: false,
      transactions: transactions,
      username: username,
      hasCreatedWallet: _preferenceService.hasCreatedWallet,
    ));
  }

  void updateWalletBalance(CoinType coinType) async {
    final Wallet? wallet = await _preferenceService.getWallet(coinType);
    debugPrint("new wallet value is $wallet");
    emit(state.copyWith(wallet: wallet));
  }
}
