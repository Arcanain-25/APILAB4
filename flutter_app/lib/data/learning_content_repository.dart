import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/repositories/learning_content_repository.dart';
import 'learning_content.dart';

class HttpLearningContentRepository implements LearningContentRepository {
  HttpLearningContentRepository({http.Client? client})
      : _client = client ?? http.Client();

  static const _feedUrl =
      'https://test-api-jlbn.onrender.com/lab2026/v4/feed';
  static const _detailsUrl =
      'https://test-api-jlbn.onrender.com/lab2026/v4/feed/details';

  final http.Client _client;

  @override
  Future<LearningContent> load() async {
    final responses = await Future.wait([
      _client.get(Uri.parse(_feedUrl)),
      _client.get(Uri.parse(_detailsUrl)),
    ]);

    for (final response in responses) {
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode} while loading data');
      }
    }

    final homeJson = jsonDecode(responses[0].body) as Map<String, dynamic>;
    final detailsJson = jsonDecode(responses[1].body) as Map<String, dynamic>;

    return LearningContent.fromJson({
      'homePage': homeJson,
      'courseOverviewPage': detailsJson,
    });
  }
}
