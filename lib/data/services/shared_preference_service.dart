import 'dart:convert';
import 'dart:math';

import 'package:flutter_crypto_wallet/data/models/coin_type.dart';
import 'package:flutter_crypto_wallet/data/models/transaction.dart';
import 'package:flutter_crypto_wallet/data/models/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

const String _walletValueKey = "_walletValueKey";
const String _usernameValueKey = "_usernameValueKey";
const String _transactionsKey = "_transactionsKey";

class SharedPreferenceService {
  final SharedPreferences _sharedPreferences;

  SharedPreferenceService(this._sharedPreferences);

  Future<void> createWallet(int amount, CoinType coinType, {String? username}) async {
    final wallet = [Wallet(coinType: coinType.name, amount: amount)];
    await _sharedPreferences.setString(_walletValueKey, jsonEncode(wallet));
    if (username != null && username.isNotEmpty) await saveUsername(username);
  }

  Future<void> fundWallet(int amount, CoinType coinType) async {
    final wallets = await getWallets();
    final int index = wallets.indexWhere((element) => element.coinType == coinType.name);
    if (index.isNegative) {
      wallets.add(Wallet(coinType: coinType.name, amount: amount));
      await _sharedPreferences.setString(_walletValueKey, jsonEncode(wallets));
    } else {
      final wallet = wallets[index];
      int walletAmount = wallet.amount;
      wallets[index] = wallet.copyWith(amount: walletAmount += amount);
      await _sharedPreferences.setString(_walletValueKey, jsonEncode(wallets));
    }
  }

  Future<void> updateWallet(Wallet wallet) async {
    final wallets = await getWallets();
    final int index = wallets.indexWhere((element) => element.coinType == wallet.coinType);
    if (index.isNegative) return;
    wallets[index] = wallet;
    await _sharedPreferences.setString(_walletValueKey, jsonEncode(wallets));
  }

  Future<Wallet?> getWallet(CoinType coinType) async {
    final wallets = await getWallets();
    return wallets.firstWhere((wallet) => wallet.coinType == coinType.name,
        orElse: () => Wallet(coinType: coinType.name, amount: 0));
  }

  Future<List<Wallet>> getWallets() async {
    if (!hasCreatedWallet) return [];
    final coins = _sharedPreferences.getString(_walletValueKey);
    return List.from(jsonDecode(coins!)).map((e) => Wallet.fromJson(e)).toList();
  }

  bool get hasCreatedWallet {
    final String? walletValue = _sharedPreferences.getString(_walletValueKey);
    return walletValue != null;
  }

  Future<void> createTransaction(
    CoinType coinType,
    String customerName,
    String country,
    int amount,
  ) async {
    final isSuccessfulTransaction = Random().nextBool();

    final recentTransactions = await getRecentTransactions();

    debugPrint("recentTransactions $recentTransactions");

    final transaction = Transaction(
      coinType: coinType,
      customerName: customerName,
      countryOfOrigin: country,
      amount: amount,
      isSuccessful: isSuccessfulTransaction,
    );

    Wallet? wallet = await getWallet(coinType);
    if (wallet != null && amount > wallet.amount) {
      throw const InvalidTransferAmountException('Invalid transfer amount');
    } else {
      recentTransactions.add(transaction);
      await _sharedPreferences.setString(_transactionsKey, jsonEncode(recentTransactions));

      if (!transaction.isSuccessful) {
        throw const TransactionFailedException("Transaction failed, please try again later");
      } else {
        int walletBalance = wallet!.amount;
        int newBalance = walletBalance -= amount;
        wallet = wallet.copyWith(amount: newBalance);
        updateWallet(wallet);
      }
    }
  }

  Future<List<Transaction>> getRecentTransactions() async {
    final String? transValue = _sharedPreferences.getString(_transactionsKey);
    if (transValue == null || transValue.isEmpty) return Future.value([]);
    final transactions =
        List.from(jsonDecode(transValue)).map((e) => Transaction.fromJson(e)).toList();
    return Future.value(transactions);
  }

  Future<void> saveUsername(String username) async {
    await _sharedPreferences.setString(_usernameValueKey, username);
  }

  String? getUsername() {
    return _sharedPreferences.getString(_usernameValueKey);
  }
}

class InvalidTransferAmountException implements Exception {
  final String message;

  const InvalidTransferAmountException(this.message);
}

class TransactionFailedException implements Exception {
  final String message;

  const TransactionFailedException(this.message);
}
