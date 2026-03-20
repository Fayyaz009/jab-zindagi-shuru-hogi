import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ImageShareService {
  static final ScreenshotController screenshotController = ScreenshotController();

  static Future<void> shareWidgetAsImage(context, String text) async {
    // This will be used with Screenshot widget
  }

  static Future<void> shareImage(Uint8List bytes, String text) async {
    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/quote_share.png').create();
    await imagePath.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(imagePath.path)],
      text: '$text\n\nRead more in Jab Zindagi Shuru Hogi app: https://play.google.com/store/apps/details?id=com.jabzindagishuruhogi.inzaar',
    );
  }
}
