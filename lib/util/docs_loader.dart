import 'dart:convert';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DocsUtil {
  List<Map<String, dynamic>>? documentationData;

  Future<void> load_data_per_context() async {
    var url = Uri.parse('https://api.github.com/repos/casas1010/simple_ticket_docs/contents/documentation.xlsx');

    // var token = dotenv.env['GITHUB_TOKEN'];
    var token = "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";

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'token $token',
      },
    );

    print("response:: ${response.statusCode}");

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var downloadUrl = jsonResponse['download_url'];

      var fileResponse = await http.get(Uri.parse(downloadUrl));

      if (fileResponse.statusCode == 200) {
        var bytes = fileResponse.bodyBytes;
        Excel? _excel = Excel.decodeBytes(Uint8List.fromList(bytes));

        if (_excel != null) {
          var sheet = _excel.tables['data per context'];

          if (sheet != null) {
            var rows = sheet.rows;
            var columns = rows[0].map((cell) => cell?.value?.toString()).toList();

            // Transform the data into the expected type
            documentationData = rows.skip(1).map((row) {
              return Map.fromIterables(
                columns.map((col) => col ?? ''), // Ensure keys are non-null
                row.map((cell) => cell?.value?.toString() ?? ''), // Ensure values are non-null
              );
            }).toList();
          } else {
            throw Exception("Sheet 'data per context' not found in the Excel file");
          }
        } else {
          throw Exception("No tables found in the Excel file");
        }
      } else {
        throw Exception("Failed to download Excel file");
      }
    } else {
      throw Exception("Failed to load Excel file metadata");
    }
  }
}