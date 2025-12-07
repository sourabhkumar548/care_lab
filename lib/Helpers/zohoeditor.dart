import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class ZohoEditorService {
  static Future<void> openEditor(String fileUrl) async {
    final res = await http.post(
      Uri.parse("https://dzda.in/DocApi/public/api/zoho/editor"),
      body: {"fileUrl": fileUrl},
    );

    print("RESPONSE BODY: ${res.body}");

    final data = jsonDecode(res.body);

    final editorUrl = data["document_url"];

    html.window.open(editorUrl, "_blank");
  }
}

