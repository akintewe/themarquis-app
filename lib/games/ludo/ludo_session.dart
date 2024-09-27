import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:marquis_v2/env.dart';
import 'package:marquis_v2/models/ludo_session.dart';
import 'package:marquis_v2/providers/app_state.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

part "ludo_session.g.dart";

final baseUrl = environment['build'] == 'DEBUG'
    ? environment['apiUrlDebug']
    : environment['apiUrl'];
final wsUrl = environment['build'] == 'DEBUG'
    ? environment['wsUrlDebug']
    : environment['wsUrl'];

@Riverpod(keepAlive: true)
class LudoSession extends _$LudoSession {
  //Details Declaration
  Box<LudoSessionData>? _hiveBox;
  late WebSocketChannel _channel;
  String? _id;

  @override
  LudoSessionData? build() {
    _hiveBox ??= Hive.box<LudoSessionData>("ludoSession");
    _connectWebSocket();
    return null;
  }

  void _connectWebSocket() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl!));
      _channel.stream.listen(
        (data) async {
          print("WS: $data");
          final decodedResponse = jsonDecode(data) as Map;
          switch (decodedResponse['event']) {
            case 'play_move':
            case 'player_joined':
            case 'play_move_failed':
              final dataStr = decodedResponse['data'] as String;
              print('Data String ${dataStr}');
              final data = jsonDecode(dataStr) as Map;
              print('Data $data');
              if (data["session_id"] == _id) {
                await getLudoSession();
              }
              break;
          }
        },
        onDone: () {
          _connectWebSocket();
        },
        onError: (error) {
          print('WS Error $error');
          _connectWebSocket();
        },
      );
    } catch (e) {
      print('WS Connection Error $e');
      _connectWebSocket();
    }
  }

  Future<void> getLudoSession() async {
    if (_id == null) {
      _id = ref.read(userProvider)?.sessionId;
      if (_id == null) return;
    }
    final url = Uri.parse('$baseUrl/game/session/$_id');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': ref.read(appStateProvider).bearerToken,
      },
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    final ludoSession = LudoSessionData(
      id: _id!,
      status: decodedResponse['status'],
      nextPlayer: decodedResponse['next_player'],
      nonce: decodedResponse['nonce'],
      color: decodedResponse['color'] ?? "0",
      playAmount: decodedResponse['play_amount'],
      playToken: decodedResponse['play_token'],
      sessionUserStatus: [
        ...decodedResponse['session_user_status'].map(
          (e) {
            final List<String> playerTokensPosition =
                (e['player_tokens_position'] as List<dynamic>)
                    .map((e) => e.toString())
                    .toList();
            final List<bool> playerWinningTokens =
                (e['player_winning_tokens'] as List<dynamic>)
                    .map((e) => e as bool)
                    .toList();
            final List<bool> playerTokensCircled =
                (e['player_tokens_circled'] as List<dynamic>)
                    .map((e) => e as bool)
                    .toList();
            return LudoSessionUserStatus(
              playerId: e['player_id'],
              playerTokensPosition: playerTokensPosition,
              playerWinningTokens: playerWinningTokens,
              playerTokensCircled: playerTokensCircled,
              userId: e['user_id'],
              email: e['email'],
              role: e['role'],
              status: e['status'],
              points: e['points'],
            );
          },
        ),
      ],
      nextPlayerId: decodedResponse['next_player_id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          decodedResponse['created_at'] * 1000),
      creator: "",
    );
    await _hiveBox!.put(_id, ludoSession);
    state = ludoSession;
  }

  Future<List<LudoSessionData>> getOpenSessions() async {
    final url = Uri.parse('$baseUrl/session/get-open-sessions');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return decodedResponse
        .map((sessionData) => LudoSessionData(
              id: sessionData['id'],
              status: sessionData['status'],
              nextPlayer: sessionData['next_player'],
              nonce: sessionData['nonce'],
              color: sessionData['color'] ?? "0",
              playAmount: sessionData['play_amount'],
              playToken: sessionData['play_token'],
              sessionUserStatus: [
                ...sessionData['session_user_status'].map(
                  (e) {
                    final List<String> playerTokensPosition =
                        (e['player_tokens_position'] as List<dynamic>)
                            .map((e) => e.toString())
                            .toList();
                    final List<bool> playerWinningTokens =
                        (e['player_winning_tokens'] as List<dynamic>)
                            .map((e) => e as bool)
                            .toList();
                    final List<bool> playerTokensCircled =
                        (e['player_tokens_circled'] as List<dynamic>)
                            .map((e) => e as bool)
                            .toList();
                    return LudoSessionUserStatus(
                      playerId: e['player_id'],
                      playerTokensPosition: playerTokensPosition,
                      playerWinningTokens: playerWinningTokens,
                      playerTokensCircled: playerTokensCircled,
                      userId: e['user_id'],
                      email: e['email'],
                      role: e['role'],
                      status: e['status'],
                      points: e['points'],
                    );
                  },
                ),
              ],
              nextPlayerId: sessionData['next_player_id'],
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                  sessionData['created_at'] * 1000),
              creator: "",
            ))
        .toList();
  }

  Future<List<int>> generateMove() async {
    final url = Uri.parse('$baseUrl/game/session/$_id/generate-move');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': ref.read(appStateProvider).bearerToken,
      },
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return decodedResponse.map((e) => e as int).toList();
  }

  Future<void> playMove(String tokenId) async {
    final url = Uri.parse('$baseUrl/game/session/$_id/play-move/$tokenId');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': ref.read(appStateProvider).bearerToken,
      },
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<List<Map>> getTransactions() async {
    final url = Uri.parse('$baseUrl/game/session/$_id/transactions');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': ref.read(appStateProvider).bearerToken,
      },
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    print(decodedResponse);
    return decodedResponse.map((e) => e as Map).toList();
  }

  Future<void> clearData() async {
    _hiveBox!.delete("ludoSession");
    state = null;
  }

  Future<void> createSession(
      String amount, String color, String tokenAddress) async {
    final url = Uri.parse('$baseUrl/session/create');
    final response = await http.post(
      url,
      body: jsonEncode({
        'amount': amount,
        'color': color,
        // 'token_address': tokenAddress,
        'token_address': '0',
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': ref.read(appStateProvider).bearerToken,
      },
    );
    if (response.statusCode != 201) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
    _id = decodedResponse['id'];
    await getLudoSession();
    await ref.read(userProvider.notifier).getUser();
  }

  Future<void> joinSession(String sessionId) async {
    final url = Uri.parse('$baseUrl/session/join');
    final response = await http.post(
      url,
      body: jsonEncode({'session_id': sessionId}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': ref.read(appStateProvider).bearerToken,
      },
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
    _id = sessionId;
    await getLudoSession();
    await ref.read(userProvider.notifier).getUser();
  }

  Future<void> closeSession(String tokenId) async {
    final url = Uri.parse('$baseUrl/session/close');
    final response = await http.post(
      url,
      body: jsonEncode({'session_id': _id}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
    await ref.read(userProvider.notifier).getUser();
  }

  Future<void> editLudoSession(
    String firstName,
    String lastName,
    DateTime birthdate,
    String gender,
    String country,
    String fieldOfCareer,
  ) async {
    // await ref.read(natsServiceProvider.notifier).makeMicroserviceRequest(
    //       "jomfi.editLudoSession.<LudoSession>",
    //       jsonEncode({
    //         'firstName': firstName,
    //         'lastName': lastName,
    //         'birthdate': birthdate.toIso8601String(),
    //         'gender': gender,
    //         'country': country,
    //         'fieldOfCareer': fieldOfCareer,
    //       }),
    //     );
    // state = state?.copyWith(
    //   firstName: firstName,
    //   lastName: lastName,
    //   birthdate: birthdate,
    //   gender: gender,
    //   country: country,
    //   fieldOfCareer: fieldOfCareer,
    // );
  }
}
