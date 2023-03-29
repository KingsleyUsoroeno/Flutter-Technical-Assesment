import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/data/models/coin_type.dart';
import 'package:flutter_crypto_wallet/data/models/transaction.dart';

class RecentTransaction extends StatelessWidget {
  final Transaction transaction;

  const RecentTransaction({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Color(0x13000000), offset: Offset(0, 2), blurRadius: 4.0)]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(transaction.coinType.image), fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.customerName,
                          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Total: ${transaction.transAmount} ${transaction.coinType.name.toUpperCase()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15, color: Color(0xFF343A40)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        transaction.countryOfOrigin,
                        style: const TextStyle(color: Color(0xFF343A40), fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        transaction.isSuccessful ? 'Successfully Completed' : 'Transaction failed',
                        style: TextStyle(
                            color: transaction.isSuccessful ? const Color(0xFF21BF73) : Colors.red,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
