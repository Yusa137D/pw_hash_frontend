import 'dart:html' as html;

Future<bool> openPdfUrl(String url) async {
  html.window.open(url, '_blank');
  return true;
}
