import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquis_v2/games/checkers/core/constants/contract_constant.dart';
import 'package:starknet/starknet.dart';

final accountProvider = FutureProvider<Account>((ref) async {
  final provider = JsonRpcProvider(
    nodeUri: ContractConstants.providerUrl,
  );
  
  final privateKey = Felt.fromString('  ');
  final signer = Signer(privateKey: privateKey);
  
  return Account(
    provider: provider,
    signer: signer,
    accountAddress: ContractConstants.contractAddress,
    chainId: ContractConstants.chainId,
  );
});
