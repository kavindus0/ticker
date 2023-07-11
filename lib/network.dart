import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelp {
  String currency1;
  String currency2;
  NetworkHelp(this.currency1, this.currency2);

  Future<dynamic> fetchData() async {
    var url = Uri.parse(
        'https://api.api-ninjas.com/v1/exchangerate?pair=${currency1}_$currency2');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'VaOfbU4pAfH2uBpLCFDPiRhyevg6W3Ou6nShl2yh',
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      String data = response.body;
      double valueAfterConversation = await jsonDecode(data)['exchange_rate'];
      return valueAfterConversation;
      // Process the data as needed
    } else {
      print('Error: ${response.body}');
    }
  }
}
