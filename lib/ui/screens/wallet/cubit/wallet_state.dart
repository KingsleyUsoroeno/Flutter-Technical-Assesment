part of 'wallet_cubit.dart';

enum AppStatus { idle, loading, success }

class WalletState extends Equatable {
  final AppStatus appStatus;
  final bool hasCreatedWallet;

  const WalletState({required this.appStatus, this.hasCreatedWallet = false});

  bool get isLoading => appStatus == AppStatus.loading;

  @override
  List<Object?> get props => [appStatus, hasCreatedWallet];


  const WalletState.idle() : this(appStatus: AppStatus.idle);

  const WalletState.success() : this(appStatus: AppStatus.success);
}
