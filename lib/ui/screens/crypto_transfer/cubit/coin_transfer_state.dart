part of 'coin_transfer_cubit.dart';

abstract class CoinTransferState extends Equatable {
  const CoinTransferState();

  @override
  List<Object?> get props => [];
}

class CoinTransferInitialState extends CoinTransferState {}

class CoinTransferLoadingState extends CoinTransferState {}

class CoinTransferSuccessState extends CoinTransferState {}

class CoinTransferErrorState extends CoinTransferState {
  final String errorMessage;

  const CoinTransferErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
