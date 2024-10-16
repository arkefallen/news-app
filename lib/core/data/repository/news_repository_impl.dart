import 'dart:convert';

import 'package:news_app/core/constants.dart';
import 'package:news_app/core/data/news_response_dto.dart';
import 'package:news_app/core/domain/repository/news_repository.dart';
import 'package:http/http.dart' as http;

class NewsRepositoryImpl extends NewsRepository {
  @override
  Future<NewsResponseDto> fetchAllNews() async {
    throw UnimplementedError();
  }

  @override
  Future<NewsResponseDto> fetchTopHeadlines() async {
    try {
      final response = await http.get(Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey&category=general'));

      if (response.statusCode == 200) {
        return NewsResponseDto.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed To Fetch Data");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
