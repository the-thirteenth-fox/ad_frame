import 'package:url_launcher/url_launcher_string.dart';

import 'logger.dart';

openLink(String url) {
  launchUrlString(url);
  Log.instance.log('ADFRAME :: openedLink :: $url', hide: true);
}
