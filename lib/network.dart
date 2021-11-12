import 'dart:convert';

import 'package:http/http.dart';

class Network {
  String url;
  Network(this.url);

  Future<dynamic> fetchData() async {
    Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      var parsedBody = json.decode(response.body);
      return parsedBody;
    } else {
      return response.statusCode;
    }
  }
}
