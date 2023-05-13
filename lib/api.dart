import 'package:http/http.dart' as http;
import 'dart:convert';


class Quote {
  final String quote;
  final String author;

  Quote({required this.quote, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['text'] ?? '',
      author: json['author'] ?? '',
    );
  }
}

Future<List<Quote>> getQuotes(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body) as List<dynamic>;
    List<Quote> quotes = jsonData.map((item) => Quote.fromJson(item)).toList();
    return quotes;
  } else {
    throw Exception('Error loading Quotes');
  }
}

