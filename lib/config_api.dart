import 'package:ad_frame/models/config.dart';
import 'package:ad_frame/utils/logger.dart';
import 'package:http/http.dart';

class AdConfigApi {
  static Future<AdFrameConfig?> get getAdConfig async {
    String path = 'https://tfox.dev/ad_config/config.json';
    try {
      final response = await get(Uri.parse(path));
      if (response.statusCode == 200) {
        final result = AdFrameConfig.fromJson(response.body);
        Log.instance.log('ADFRAME :: succes to get configs 😻');
        return result;
      }
    } catch (e) {
      Log.instance.log('ADFRAME :: onGetConfig :: $e');
    }
    return null;
  }
}
