import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_crypto_wallet/data/models/coin_type.dart';
import 'package:flutter_crypto_wallet/data/services/shared_preference_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_crypto_wallet/di/injection_util.dart';
import 'package:flutter_crypto_wallet/ui/screens/home/cubit/home_screen_cubit.dart';

part 'coin_transfer_state.dart';

class CoinTransferCubit extends Cubit<CoinTransferState> {
  final SharedPreferenceService _preferenceService;

  CoinTransferCubit(this._preferenceService) : super(CoinTransferInitialState());

  Future<void> transferCoins(
      CoinType coinType, String customerName, String country, int amount) async {
    try {
      emit(CoinTransferLoadingState());
      await Future.delayed(const Duration(milliseconds: 600));
      await _preferenceService.createTransaction(coinType, customerName, country, amount);
      emit(CoinTransferSuccessState());
    } on InvalidTransferAmountException catch (exception) {
      emit(CoinTransferErrorState(exception.message));
    } on TransactionFailedException catch (exception) {
      emit(CoinTransferErrorState(exception.message));
    } catch (exception, stackTrace) {
      debugPrint("exception is $exception and stackTrace is $stackTrace");
      emit(const CoinTransferErrorState("Something went wrong"));
    }
    getIt<HomeScreenCubit>().fetchData(coinType);
  }
}
