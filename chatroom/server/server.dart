import 'dart:io';
import 'dart:convert';

class ChatClient {
  Socket _socket;
  String _address;
  int _port;

  ChatClient(Socket s) {
    _socket = s;
    _address = _socket.remoteAddress.address;
    _port = _socket.remotePort;

    _socket.listen(messageHandler,
        onError: errorHandler, onDone: finishedHandler);
  }

  void messageHandler(data) {
    String message = new String.fromCharCodes(data).trim();
    distributeMessage(this, jsonEncode(message));
    print(message);
  }

  void errorHandler(error) {
    print('${_address}:${_port} Error: $error');
    removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    print('${_address}:${_port} Disconnected');
    removeClient(this);
    _socket.close();
  }

  void write(String message) {
    _socket.write(message);
  }
}

ServerSocket server;
List<ChatClient> clients = [];

void main() {
  ServerSocket.bind(InternetAddress.anyIPv4, 4567).then((ServerSocket socket) {
    server = socket;
    server.listen((client) {
      handleConnection(client);
    });
  });
}

void handleConnection(Socket client) {
  print('Connection from '
      '${client.remoteAddress.address}:${client.remotePort}');
  clients.add(new ChatClient(client));
}

void distributeMessage(ChatClient client, String message) {
  for (ChatClient c in clients) {
    if (c != client) {
      c.write(message + "\n");
    }
  }
}

void removeClient(ChatClient client) {
  clients.remove(client);
}
