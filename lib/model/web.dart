import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnctionWs {
  bool isConn;
  String url;
  WebSocketChannel? channel;

  ConnctionWs(
    this.url, {
    this.channel,
    this.isConn = false,
  }) {
    channel = IOWebSocketChannel.connect(url);
    isConn = true;
  }
}
