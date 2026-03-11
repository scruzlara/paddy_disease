import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<Map> classifyRiceImage(String imageBase64) async {
  // Generate a random session hash
  String generateSessionHash() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final result =
        List.generate(11, (index) => chars[random.nextInt(chars.length)])
            .join();
    return result;
  }

  // Generate a session hash
  final sessionHash = generateSessionHash();
  // Animefy the given image by requesting the gradio API of AnimeGANv2
  final response = await http.post(
    Uri.parse(
        //'https://europython2022-paddy-disease-classification.hf.space/api/predict'),
        'https://scruzlara-paddy-disease-classification.hf.space/api/predict'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'data': [
        imageBase64,
      ],
      'session_hash': sessionHash,
      'fn_index': 0 // Adding this as it's often required by Gradio
    }),
  );

  debugPrint('Response status: ${response.statusCode}');
  debugPrint('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final classificationResult = jsonDecode(response.body)["data"][0];
    return classificationResult;
    // If the server did return a 200 CREATED response,
    // then decode the image and return it.
    // final imageData = jsonDecode(response.body)["data"][0]
    //     .replaceAll('data:image/png;base64,', '');
    // return base64Decode(imageData);
  } else {
    // If the server did not return a 200 OKAY response,
    // then throw an exception.
    throw Exception('Failed to classify image.');
  }
}
