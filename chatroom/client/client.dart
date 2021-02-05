import 'dart:async';
import 'dart:io';

Socket socket;

void main() {
  Socket.connect("localhost", 4567)
    .then((Socket sock) {
      socket = sock;
      socket.listen(dataHandler, 
        onError: errorHandler, 
        onDone: doneHandler, 
        cancelOnError: false);
    })
    .catchError((AsyncError e) {
      print("Unable to connect: $e");
      exit(1);
    });

  stdin.listen((data) => 
      socket.write(
        new String.fromCharCodes(data).trim() + '\n'));
}

void dataHandler(data){
  print(new String.fromCharCodes(data).trim());
}

void errorHandler(error, StackTrace trace){
  print(error);
}

void doneHandler(){
  socket.destroy();
  exit(0);
}