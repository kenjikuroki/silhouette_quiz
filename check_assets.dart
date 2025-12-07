import 'dart:io';

void main() {
  final file = File('lib/state/quiz_app_state.dart');
  final content = file.readAsStringSync();
  
  // Regex to find asset paths. Matches strings starting with 'assets/images/' and ending with '.png' or similar.
  // We assume single quotes are used as per the file style.
  final regex = RegExp(r"'assets/images/[^']+'");
  
  final matches = regex.allMatches(content);
  
  print('Found ${matches.length} asset references.');
  
  int missingCount = 0;
  for (final match in matches) {
    String path = match.group(0)!;
    // Remove quotes
    path = path.substring(1, path.length - 1);
    
    final assetFile = File(path);
    if (!assetFile.existsSync()) {
      print('MISSING: $path');
      missingCount++;
    }
  }
  
  if (missingCount == 0) {
    print('All assets exist!');
  } else {
    print('Total missing assets: $missingCount');
  }
}
