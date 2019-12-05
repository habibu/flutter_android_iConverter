import 'dart:io';
import 'dart:convert' show json, utf8;
import 'dart:async';

const apiCategory = {
  'name': 'Currency',
  'route': 'currency',
};

class Api {
  final HttpClient _httpClient = HttpClient();

  // The API end point to make the request
  final String _url = 'flutter.udacity.com';

  Future<List> getUnits(String category) async {
    final uri = Uri.https(_url, '/$category');
    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null || jsonResponse['units'] == null) {
      print('Error retrieving units');
      return null;
    }
    return jsonResponse['units'];
  }

  Future<double> convert(
      String category, String amount, String fromUnit, String toUnit) async {
    final uri = Uri.https(_url, '/$category/convert',
        {'amount': amount, 'from': fromUnit, 'to': toUnit});
    final jsoResponse = await _getJson(uri);
    if (jsoResponse == null || jsoResponse['status'] == null) {
      print('Error retrieving conversion.');
      return null;
    } else if (jsoResponse['status'] == 'error') {
      print(jsoResponse['message']);
      return null;
    }
    return jsoResponse['conversion'].toDouble();
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();

      if (httpResponse.statusCode != HttpStatus.ok) {
        return null;
      }

      final responseBody = await httpResponse.transform(utf8.decoder).join();

      return json.decode(responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }
}
