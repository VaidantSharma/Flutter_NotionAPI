import 'dart:convert';
import 'package:http/http.dart' as http;
import 'NewsClass.dart';

class NewsRepo {
  final http.Client _client;
  static const String _notionApiKey = "YOUR NOTION API KEY";
  static const String _databaseId = "YOUR DATABASE ID";
  static const String _notionVersion = "2022-06-28";

  NewsRepo({http.Client? client}) : _client = client ?? http.Client();

  Future<List<News>> getNews() async {
    final url = Uri.parse("https://api.notion.com/v1/databases/$_databaseId/query");

    final response = await _client.post(
      url,
      headers: {
        "Authorization": "Bearer $_notionApiKey",
        "Notion-Version": _notionVersion,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> results = jsonResponse['results'];

      return results.map((item) => News.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load news: ${response.body}");
    }
  }

  void dispose() {
    _client.close();
  }
}
