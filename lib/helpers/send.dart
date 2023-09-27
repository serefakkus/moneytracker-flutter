import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<dynamic> sendData(dynamic exportJson, WebSocketChannel channel) async {
  channel.sink.add(exportJson);

  bool pass = false;
  dynamic inJson;

  channel.stream.listen(
    (data) {
      inJson = jsonDecode(data);
      pass = true;
      channel.sink.close();
    },
    onDone: () {
      pass = true;
    },
    onError: (e) {
      debugPrint(e.toString());
      pass = true;
    },
  );

  for (var counter = 0; counter < 60; counter++) {
    if (pass) {
      counter = 60;
    }

    await Future.delayed(const Duration(seconds: 1));
  }

  return inJson;
}
