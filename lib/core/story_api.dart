import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'story.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class StoryApi {
  StoryApi({http.Client? client}) : _client = client ?? http.Client();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://story-api.dicoding.dev/v1',
  );

  final http.Client _client;

  Uri _uri(String path, [Map<String, String>? query]) {
    return Uri.parse('$baseUrl$path').replace(queryParameters: query);
  }

  Map<String, dynamic> _decode(http.Response response) {
    Map<String, dynamic> body;
    try {
      body = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw const ApiException('Respons server tidak dapat dibaca.');
    } on TypeError {
      throw const ApiException('Format respons server tidak valid.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        body['message'] as String? ?? 'Permintaan gagal. Coba lagi.',
        statusCode: response.statusCode,
      );
    }
    return body;
  }

  Future<Map<String, dynamic>> _postJson(
    String path,
    Map<String, String> values,
  ) async {
    final response = await _client.post(
      _uri(path),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(values),
    );
    return _decode(response);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _postJson('/register', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<({String token, String name})> login({
    required String email,
    required String password,
  }) async {
    final body = await _postJson('/login', {
      'email': email,
      'password': password,
    });
    final result = body['loginResult'] as Map<String, dynamic>?;
    final token = result?['token'] as String?;
    if (token == null || token.isEmpty) {
      throw const ApiException('Server tidak mengirimkan token sesi.');
    }
    return (token: token, name: result?['name'] as String? ?? 'Pengguna');
  }

  Future<List<Story>> fetchStories(String token) async {
    final response = await _client.get(
      _uri('/stories', {'page': '1', 'size': '30'}),
      headers: {'Authorization': 'Bearer $token'},
    );
    final body = _decode(response);
    final stories = body['listStory'] as List<dynamic>? ?? const [];
    final result = stories
        .whereType<Map<String, dynamic>>()
        .map(Story.fromJson)
        .toList();
    result.sort((first, second) => second.createdAt.compareTo(first.createdAt));
    return result;
  }

  Future<Story> fetchStory(String token, String id) async {
    final response = await _client.get(
      _uri('/stories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final body = _decode(response);
    final story = body['story'] as Map<String, dynamic>?;
    if (story == null) {
      throw const ApiException('Cerita tidak ditemukan.');
    }
    return Story.fromJson(story);
  }

  Future<void> addStory({
    required String token,
    required XFile image,
    required String description,
  }) async {
    final extension = image.name.split('.').last.toLowerCase();
    final subtype = switch (extension) {
      'png' => 'png',
      'webp' => 'webp',
      'gif' => 'gif',
      _ => 'jpeg',
    };
    final request = http.MultipartRequest('POST', _uri('/stories'))
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['description'] = description
      ..files.add(
        http.MultipartFile.fromBytes(
          'photo',
          await image.readAsBytes(),
          filename: image.name,
          contentType: MediaType('image', subtype),
        ),
      );
    final response = await http.Response.fromStream(await request.send());
    _decode(response);
  }
}
