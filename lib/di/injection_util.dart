import 'package:flutter_crypto_wallet/data/services/shared_preference_service.dart';
import 'package:flutter_crypto_wallet/ui/screens/crypto_transfer/cubit/coin_transfer_cubit.dart';
import 'package:flutter_crypto_wallet/ui/screens/home/cubit/home_screen_cubit.dart';
import 'package:flutter_crypto_wallet/ui/screens/wallet/cubit/wallet_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  getIt
      .registerLazySingleton<SharedPreferenceService>(() => SharedPreferenceService(getIt.get()));
  getIt.registerLazySingleton<HomeScreenCubit>(() => HomeScreenCubit(getIt.get()));
  getIt.registerFactory<WalletCubit>(() => WalletCubit(getIt.get()));
  getIt.registerFactory<CoinTransferCubit>(() => CoinTransferCubit(getIt.get()));
}
