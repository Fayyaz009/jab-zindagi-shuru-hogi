import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/models/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class NoteSharingService {
  static Future<void> shareNoteAsImage(GlobalKey boundaryKey, NoteModel note) async {
    try {
      // Small delay to ensure the UI has settled if it was just built
      await Future.delayed(const Duration(milliseconds: 100));

      RenderRepaintBoundary? boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) {
        debugPrint('Error: Boundary is null');
        return;
      }

      // Optimization: Check if the boundary is still attached
      if (!boundary.attached) {
        debugPrint('Error: Boundary is not attached');
        return;
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final buffer = byteData.buffer.asUint8List();
      final directory = await getTemporaryDirectory(); // Use temp dir for sharing
      final imagePath = '${directory.path}/note_share_${DateTime.now().millisecondsSinceEpoch}.png';
      
      File imageFile = File(imagePath);
      await imageFile.writeAsBytes(buffer);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(imagePath)],
          subject: 'Highlight from ${note.chapterTitle}',
          text:
              '${note.text}\n\n— from ${note.chapterTitle}\nRead more in Jab Zindagi Shuru Hogi app!',
        ),
      );

      // Clean up after share
      Future.delayed(const Duration(minutes: 1), () async {
        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      });
    } catch (e) {
      debugPrint('Error sharing note: $e');
    }
  }
}
