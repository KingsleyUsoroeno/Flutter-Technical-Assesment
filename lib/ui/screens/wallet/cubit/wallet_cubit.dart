import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_crypto_wallet/data/models/coin_type.dart';
import 'package:flutter_crypto_wallet/data/services/shared_preference_service.dart';
import 'package:flutter_crypto_wallet/di/injection_util.dart';
import 'package:flutter_crypto_wallet/ui/screens/home/cubit/home_screen_cubit.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final SharedPreferenceService _preferenceService;

  WalletCubit(this._preferenceService) : super(const WalletState.idle());

  bool get hasCreatedWallet =>  _preferenceService.hasCreatedWallet;

  void initWallet(int amount, CoinType coinType, {String? username}) async {
    emit(const WalletState(appStatus: AppStatus.loading));
    await Future.delayed(const Duration(milliseconds: 1000));
    if (hasCreatedWallet) {
      await _preferenceService.fundWallet(amount, coinType);
      getIt<HomeScreenCubit>().updateWalletBalance(coinType);
    } else {
      await _preferenceService.createWallet(amount, coinType, username: username);
      getIt<HomeScreenCubit>().fetchData(coinType);
    }
    emit(WalletState(
        appStatus: AppStatus.success, hasCreatedWallet: hasCreatedWallet));
  }
}
