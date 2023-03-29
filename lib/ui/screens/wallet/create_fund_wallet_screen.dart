import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crypto_wallet/data/models/coin.dart';
import 'package:flutter_crypto_wallet/di/injection_util.dart';
import 'package:flutter_crypto_wallet/ui/components/custom_button.dart';
import 'package:flutter_crypto_wallet/ui/components/custom_text_field.dart';
import 'package:flutter_crypto_wallet/ui/screens/wallet/cubit/wallet_cubit.dart';

class CreateFundWalletScreen extends StatefulWidget {
  final Coin? coin;

  const CreateFundWalletScreen({Key? key, this.coin}) : super(key: key);

  @override
  State<CreateFundWalletScreen> createState() => _CreateFundWalletScreenState();
}

class _CreateFundWalletScreenState extends State<CreateFundWalletScreen> {
  Coin? initialSelectedValue;
  final amountController = TextEditingController();
  final usernameController = TextEditingController();

  final cubit = getIt.get<WalletCubit>();

  void _fundWallet() {
    final String inputtedAmount = amountController.text.trim();
    final String username = usernameController.text.trim();

    if (inputtedAmount.isNotEmpty || initialSelectedValue == null) {
      if ((!cubit.hasCreatedWallet && username.isEmpty)) return;

      final int amount = int.parse(inputtedAmount);
      cubit.initWallet(amount, initialSelectedValue!.coinType, username: username);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Please provide the necessary details to ${cubit.hasCreatedWallet ? 'fund' : 'create'} your wallet")));
    }
  }

  @override
  void initState() {
    super.initState();
    _initValues();
  }

  void _initValues() {
    if (widget.coin != null) {
      setState(() {
        initialSelectedValue = widget.coin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Create Wallet',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
      ),
      body: BlocConsumer<WalletCubit, WalletState>(
        bloc: cubit,
        listener: (context, state) {
          if (state.appStatus == AppStatus.success) {
            Navigator.of(context).pop();
          }
        },
        builder: (_, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!cubit.hasCreatedWallet) ...[
                    CustomTextField(
                      controller: usernameController,
                      label: "Username",
                    ),
                    const SizedBox(height: 20)
                  ],
                  const Text(
                    'Selected coin',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 48.0,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCCCCCC), width: 1.0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(initialSelectedValue?.image ?? ""),
                                  fit: BoxFit.cover)),
                        ),
                        Text(initialSelectedValue?.name ?? '')
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: amountController,
                    label: "Amount",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 30),
                  if (state.isLoading)
                    const Center(
                      child: SizedBox.square(dimension: 24, child: CircularProgressIndicator()),
                    )
                  else
                    CustomButton(
                      text: cubit.hasCreatedWallet ? 'Fund Wallet' : 'Create Wallet',
                      onPress: _fundWallet,
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
