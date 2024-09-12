import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:marquis_v2/env.dart';
import 'package:marquis_v2/models/ludo_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

part "ludo_session.g.dart";

final baseUrl = environment['apiUrl'];
final wsUrl = environment['wsUrl'];

@Riverpod(keepAlive: true)
class LudoSession extends _$LudoSession {
  //Details Declaration
  Box<LudoSessionData>? _hiveBox;
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse(wsUrl!),
  );
  String? _id;

  @override
  LudoSessionData? build() {
    _hiveBox ??= Hive.box<LudoSessionData>("ludoSession");
    _channel.stream.listen((data) => print(data));
    return null;
  }

  Future<void> getLudoSession() async {
    if (_id == null) return;
    final url = Uri.parse('$baseUrl/game/session/$_id');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    final ludoSession = LudoSessionData(
      id: _id!,
      playerCount: decodedResponse['player_count'],
      status: decodedResponse['status'],
      nextPlayer: decodedResponse['next_player'],
      nonce: decodedResponse['nonce'],
      color: decodedResponse['color'],
      playAmount: decodedResponse['play_amount'],
      playToken: decodedResponse['play_token'],
      sessionUserStatus: [
        ...decodedResponse['session_user_status'].map(
          (e) => LudoSessionUserStatus(
            playerId: e['player_id'],
            playerTokensPosition: e['player_tokens_position'],
            playerWinningTokens: e['player_winning_tokens'],
            userId: e['user_id'],
            email: e['email'],
            role: e['role'],
            status: e['status'],
            points: e['points'],
          ),
        ),
      ],
      nextPlayerId: decodedResponse['next_player_id'],
      createdAt: decodedResponse['created_at'],
      creator: "",
      v: [],
      r: [],
      s: [],
      randomNumbers: [],
    );
    await _hiveBox!.put(_id, ludoSession);
    state = ludoSession;
  }

  Future<void> generateMove() async {
    final url = Uri.parse('$baseUrl/game/session/$_id/generate-move');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
  }

  Future<void> playMove(String tokenId) async {
    final url = Uri.parse('$baseUrl/game/session/$_id/play-move/$tokenId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
  }

  Future<Map<String, dynamic>> getTransactions() async {
    final url = Uri.parse('$baseUrl/game/session/$_id/transactions');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    print(decodedResponse);
    return decodedResponse;
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
        'token_address': tokenAddress,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
    _id = decodedResponse['id'];
    await getLudoSession();
  }

  Future<void> joinSession(String sessionId) async {
    final url = Uri.parse('$baseUrl/session/join');
    final response = await http.post(
      url,
      body: jsonEncode({'session_id': sessionId}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
    _id = sessionId;
    await getLudoSession();
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
