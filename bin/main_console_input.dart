import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:egclient/eg_client.dart';

class ConsoleInput {
  static void handle(EGClient client) {
    var cmdLine = stdin.transform(utf8.decoder);
    StreamSubscription cmdSubscription;
    cmdSubscription = cmdLine.listen((line) {
      print('egclient> $line ');
      if (line.startsWith('quit')) {
        //::Stops the EG Client
        client.stop();
        cmdSubscription.cancel();
      }
      if (line.startsWith('?go')) {
        var inputs = line.trim().split(' ');
        if (inputs.length == 1) {
          //::?go
          client.arena.enter();
        } else if (inputs.length == 2) {
          //::?go name
          client.arena.enter(inputs[1]);
        }
      }
      if (line.startsWith('?players')) {
        //::Prints out the player list
        client.arena.players.forEach((player) {
          print('Player(${player.playerId}): ${player.name}');
        });
      }
      if (line.startsWith('?target')) {
        var inputs = line.trim().split(' ');
        if (inputs.length == 1) {
          //::Who you are currently targetting
          print('Your current target: ${client.arena.pilotTarget.name}');
        } else if (inputs.length == 2) {
          //::Target the input by the name
          var name = inputs[1];
          var player = client.arena.findPlayerByName(name, exact: false);
          if (player != null) {
            client.arena.target(player.playerId);
            print('Targeting player ${player.name}');
          } else {
            print('Player \'${name}\' not found');
          }
        }
      } else {
        //::Send chat messages
        client.chat.send(line);
      }
    });
  }
}
