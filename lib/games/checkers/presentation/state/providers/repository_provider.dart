import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquis_v2/games/checkers/core/constants/contract_constant.dart';
import 'package:marquis_v2/games/checkers/core/repository/game_repository.dart';
import 'package:marquis_v2/games/checkers/presentation/state/providers/contract_provider.dart';
import 'package:starknet/starknet.dart' show Contract;

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final account = ref.watch(accountProvider).value;
  if (account == null) throw Exception('Account not initialized');
  
  final contract = Contract(
    account: account,
    address: ContractConstants.contractAddress,
  );
  
  return GameRepository(
    account: account,
    contract: contract,
  );
});