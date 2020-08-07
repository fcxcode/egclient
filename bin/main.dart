import 'package:egclient/eg_client.dart';

//::Import additional modules
//import 'package:egclient/modules/empty/empty.dart';
import 'package:egclient/modules/example/example.dart';

import 'main_console_input.dart';

void main(List<String> arguments) async {
  //::SSCU Extreme Games
  var host = '208.118.63.35';
  var port = 7900;

  //::EG-Chat account to be used for chatting in any arenas.
  var username = 'EG-Chat';
  var password = 'XQhQDWptqns55jyEHc7Jets5ZR5RjHbF';
  var client = EGClient(host, port, username, password);

  //::Listen for any chat messages
  client.chat.onMessage.listen((msg) {
    print('${msg.messageType} ${msg.playerId} ${msg.author}> ${msg.text}');
  });

  //::Add additional modules
  //Empty(client.arena, client.chat, client.shell);
  Example(client.arena, client.chat, client.shell);

  //::Run the client
  client.run();

  //::Console inputs
  ConsoleInput.handle(client);
}
