import 'package:starknet/starknet.dart';

class ContractConstants {
  static final contractAddress = Felt.fromString('YOUR_CONTRACT_ADDRESS');
  static final providerUrl = Uri.parse('YOUR_PROVIDER_URL');
  static final chainId = StarknetChainId.testNet;
}
