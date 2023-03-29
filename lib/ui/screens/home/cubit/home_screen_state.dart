part of 'home_screen_cubit.dart';

class HomeScreenState extends Equatable {
  final Wallet? wallet;
  final String? username;
  final List<Transaction> transactions;
  final bool isLoadingData;
  final bool hasCreatedWallet;

  const HomeScreenState({
    this.wallet,
    this.transactions = const <Transaction>[],
    this.isLoadingData = false,
    this.username,
    this.hasCreatedWallet = false,
  });

  String get walletBalance => wallet != null ? wallet!.balance : "0";

  int get walletAmount => wallet != null ? wallet!.amount : 0;

  HomeScreenState copyWith({
    Wallet? wallet,
    List<Transaction>? transactions,
    bool? isLoadingData,
    String? username,
    bool? hasCreatedWallet,
  }) {
    return HomeScreenState(
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      isLoadingData: isLoadingData ?? this.isLoadingData,
      username: username ?? this.username,
      hasCreatedWallet: hasCreatedWallet ?? this.hasCreatedWallet,
    );
  }

  @override
  List<Object?> get props => [wallet, transactions, isLoadingData, username, hasCreatedWallet];
}
