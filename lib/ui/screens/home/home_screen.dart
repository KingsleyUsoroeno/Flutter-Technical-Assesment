import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crypto_wallet/data/models/coin.dart';
import 'package:flutter_crypto_wallet/data/models/coin_type.dart';
import 'package:flutter_crypto_wallet/di/injection_util.dart';
import 'package:flutter_crypto_wallet/ui/components/custom_button.dart';
import 'package:flutter_crypto_wallet/ui/components/recent_transaction.dart';
import 'package:flutter_crypto_wallet/ui/routes/routes.dart';
import 'package:flutter_crypto_wallet/ui/screens/home/cubit/home_screen_cubit.dart';
import 'package:flutter_crypto_wallet/ui/theme/app_colors.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeScreenCubit = getIt.get<HomeScreenCubit>();
  Coin initialSelectedValue = availableCoins.first;

  CoinType get _coinType => initialSelectedValue.coinType;

  @override
  void initState() {
    super.initState();
    homeScreenCubit.fetchData(_coinType);
  }

  String get currentDay {
    return DateFormat("MMMM dd").format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
          bloc: homeScreenCubit,
          builder: (context, state) {
            if (state.isLoadingData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.username != null ? 'Welcome ${state.username}' : 'Hi there',
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                    Text(
                      'Today, $currentDay',
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0), color: AppColors.appBlue),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Balance',
                            style: TextStyle(
                                fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.w400),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(" ${state.walletBalance}",
                                  style: const TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)),
                              Container(
                                height: 40.0,
                                width: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.white400, width: 1.0),
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                ),
                                child: DropdownButton<Coin>(
                                  underline: const SizedBox.shrink(),
                                  value: initialSelectedValue,
                                  isExpanded: true,
                                  icon: const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.keyboard_arrow_down),
                                  ),
                                  items: availableCoins.map((Coin coin) {
                                    return DropdownMenuItem(
                                      value: coin,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(coin.image),
                                                      fit: BoxFit.cover)),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(coin.name,
                                                style: const TextStyle(
                                                    fontSize: 14, fontWeight: FontWeight.w500))
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (Coin? newValue) {
                                    setState(() {
                                      initialSelectedValue = newValue!;
                                      homeScreenCubit.updateWalletBalance(_coinType);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Make your investments count today',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 14),
                          CustomButton(
                            width: 120,
                            height: 30,
                            text: state.hasCreatedWallet ? 'Fund Wallet' : 'Create a wallet',
                            backgroundColor: Colors.white,
                            textColor: AppColors.appBlue,
                            onPress: () {
                              Navigator.pushNamed(context, AppRouter.createWalletRoute,
                                  arguments: initialSelectedValue);
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    if (state.wallet != null &&
                        initialSelectedValue.coinType.name == state.wallet!.coinType &&
                        state.walletAmount > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 26.0),
                        child: CustomButton(
                          text: 'Transfer ${initialSelectedValue.name}',
                          onPress: () {
                            Navigator.of(context).pushNamed(
                              AppRouter.cryptoTransferRoute,
                              arguments: initialSelectedValue.copyWith(
                                  availableBalance: state.walletAmount),
                            );
                          },
                        ),
                      ),
                    const Text(
                      'Recent transactions',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20.0),
                    if (state.transactions.isNotEmpty)
                      ...state.transactions.map((transaction) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: RecentTransaction(transaction: transaction),
                          ))
                    else
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: Text(
                            "Your most recent \ntransactions will appear hear",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
