// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';

// class SpotifyAuthService {
//   final Dio _dio = Dio();
//   final String clientId = '';
//   final String clientSecret = '';

//   Future<String?> getValidAccessToken() async {
//     final token = HiveHelper.getSpotifyToken();
//     final expiry = HiveHelper.getSpotifyTokenEpiry();

//     if (token == null || expiry == null || DateTime.now().isAfter(expiry)) {
//       return await _fetchAndStoreToken();
//     }

//     return token;
//   }

//   Future<String?> _fetchAndStoreToken() async {
//     try {
//       final response = await _dio.post(
//         'https://accounts.spotify.com/api/token',
//         data: 'grant_type=client_credentials',
//         options: Options(
//           headers: {
//             'Authorization': 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
//             'Content-Type': 'application/x-www-form-urlencoded',
//           },
//         ),
//       );

//       final accessToken = response.data['access_token'];
//       final expiresIn = response.data['expires_in'];
//       final expiry = DateTime.now().add(Duration(seconds: expiresIn));

//       await HiveHelper.saveSpotifyToken(accessToken, expiry);
//       return accessToken;
//     } catch (e) {
//       print('Failed to get Spotify token: $e');
//       return null;
//     }
//   }
// }
