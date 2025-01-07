import 'package:starknet/starknet.dart';

extension FeltExtensions on Felt {
  bool toBool() => toBigInt() != BigInt.zero;
}