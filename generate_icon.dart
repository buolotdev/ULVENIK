import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final imageBytes = File('assets/images/white_mountain_only.png').readAsBytesSync();
  final original = img.decodePng(imageBytes)!;
  
  // Create a solid background matching Obsidian color #101214
  final bg = img.Image(width: original.width, height: original.height);
  img.fill(bg, color: img.ColorRgba8(16, 18, 20, 255));
  
  // Composite original on top
  img.compositeImage(bg, original);
  
  File('assets/images/app_icon_solid.png').writeAsBytesSync(img.encodePng(bg));
  print('Generated app_icon_solid.png successfully.');
}
