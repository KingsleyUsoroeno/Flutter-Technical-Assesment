import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crypto_wallet/data/models/coin.dart';
import 'package:flutter_crypto_wallet/di/injection_util.dart';
import 'package:flutter_crypto_wallet/ui/components/custom_button.dart';
import 'package:flutter_crypto_wallet/ui/components/custom_text_field.dart';
import 'package:flutter_crypto_wallet/ui/screens/crypto_transfer/cubit/coin_transfer_cubit.dart';

class TransferCryptoScreen extends StatefulWidget {
  final Coin coin;

  const TransferCryptoScreen({Key? key, required this.coin}) : super(key: key);

  @override
  State<TransferCryptoScreen> createState() => _TransferCryptoScreenState();
}

class _TransferCryptoScreenState extends State<TransferCryptoScreen> {
  final _receiverNameController = TextEditingController();
  final _amountTextController = TextEditingController();
  final countryController = TextEditingController();
  final cubit = getIt.get<CoinTransferCubit>();

  void _transferCoin() {
    final String name = _receiverNameController.text.trim();
    final String amount = _amountTextController.text.trim();
    final String country = countryController.text.trim();

    if (name.isNotEmpty && amount.isNotEmpty && country.isNotEmpty) {
      cubit.transferCoins(widget.coin.coinType, name, country, int.parse(amount));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please provide all the necessary details to complete this action")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Send ${widget.coin.name}',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<CoinTransferCubit, CoinTransferState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is CoinTransferErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            Navigator.of(context).pop();
          } else if (state is CoinTransferSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Transaction completed successfully"),
              backgroundColor: Colors.green,
            ));
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: state is CoinTransferLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x13000000), offset: Offset(0, 2), blurRadius: 8.0)
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(widget.coin.image),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Available Balance',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF6C757D)),
                            ),
                            Text(
                              "${widget.coin.balance} ${widget.coin.name}",
                              style: const TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF212529)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: _receiverNameController,
                    label: "Receiver's name",
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _amountTextController,
                    label: 'Amount',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: countryController,
                    label: 'Country of Origin',
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Send ${widget.coin.name}',
                    onPress: _transferCoin,
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
