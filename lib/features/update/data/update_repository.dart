import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../domain/update_config.dart';

class UpdateRepository {
  final http.Client _client;

  /// The production URL where the JSON version config is hosted.
  /// This should be updated to point to the user's actual GitHub Pages, Netlify, or Vercel link.
  static const String defaultConfigUrl = 
      'https://fayyaz009.github.io/jab-zindagi-shuru-hogi-assets/version_config.json';

  UpdateRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the latest update configuration from the hosted static server.
  /// Returns [UpdateConfig] if successful.
  /// Returns `null` if any network error, timeout, or format exception occurs (graceful degradation).
  Future<UpdateConfig?> fetchUpdateConfig({String configUrl = defaultConfigUrl}) async {
    try {
      final uri = Uri.parse(configUrl);
      
      // Fetch with a clean 5-second timeout to avoid locking the splash screen indefinitely
      final response = await _client.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body) as Map<String, dynamic>;
        
        String platform = 'android';
        if (Platform.isIOS) {
          platform = 'ios';
        }
        
        return UpdateConfig.fromJson(jsonMap, platform);
      }
      return null;
    } catch (e) {
      // Log or handle gracefully in production
      return null;
    }
  }
}
