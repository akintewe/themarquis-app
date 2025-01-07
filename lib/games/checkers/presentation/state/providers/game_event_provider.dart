import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquis_v2/games/checkers/core/models/game_event.dart';
import 'package:starknet/starknet.dart';
import './contract_provider.dart';

final gameEventsProvider = StreamProvider<GameEvent>((ref) async* {
  final account = await ref.watch(accountProvider.future);

  try {
    while (true) {
      try {
        final movedEvents = await account.provider.call(
          request: FunctionCall(
            contractAddress: account.accountAddress,
            entryPointSelector: getSelectorByName('Moved'),
            calldata: [],
          ),
          blockId: BlockId.latest,
        );

        final killedEvents = await account.provider.call(
          request: FunctionCall(
            contractAddress: account.accountAddress,
            entryPointSelector: getSelectorByName('Killed'),
            calldata: [],
          ),
          blockId: BlockId.latest,
        );

        final winnerEvents = await account.provider.call(
          request: FunctionCall(
            contractAddress: account.accountAddress,
            entryPointSelector: getSelectorByName('Winner'),
            calldata: [],
          ),
          blockId: BlockId.latest,
        );

        final kingEvents = await account.provider.call(
          request: FunctionCall(
            contractAddress: account.accountAddress,
            entryPointSelector: getSelectorByName('King'),
            calldata: [],
          ),
          blockId: BlockId.latest,
        );

        GameEvent? event;

        event = movedEvents.when(
          result: (data) => GameEvent.moved({
            'session_id': data[0].toString(),
            'player': data[1].toString(),
            'row': data[2].toInt(),
            'col': data[3].toInt(),
          }),
          error: (error) {
            print('Error getting Moved events: ${error.message}');
            return null;
          },
        );
        if (event != null) yield event;

        event = killedEvents.when(
          result: (data) => GameEvent.killed({
            'session_id': data[0].toString(),
            'player': data[1].toString(),
            'row': data[2].toInt(),
            'col': data[3].toInt(),
          }),
          error: (error) {
            print('Error getting Killed events: ${error.message}');
            return null;
          },
        );
        if (event != null) yield event;

        event = winnerEvents.when(
          result: (data) => GameEvent.winner({
            'session_id': data[0].toString(),
            'player': data[1].toString(),
            'position': data[2].toInt(),
          }),
          error: (error) {
            print('Error getting Winner events: ${error.message}');
            return null;
          },
        );
        if (event != null) yield event;

        event = kingEvents.when(
          result: (data) => GameEvent.king({
            'session_id': data[0].toString(),
            'player': data[1].toString(),
            'row': data[2].toInt(),
            'col': data[3].toInt(),
          }),
          error: (error) {
            print('Error getting King events: ${error.message}');
            return null;
          },
        );
        if (event != null) yield event;

        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        print('Error polling events: $e');
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  } catch (e) {
    throw Exception('Failed to initialize event listener: $e');
  }
});
