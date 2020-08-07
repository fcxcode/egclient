import 'package:egclient/eg_client.dart';

class Example {
  final Arena _arena;
  final Chat _chat;
  final Shell _shell;

  Example(this._arena, this._chat, this._shell) {
    //::Register your commands!
    _shell.register(ShellModule('', '', 'Hello World!', [
      //::This cmd can only be access by private message
      ShellCommand('say', 'say', 'Say something...',
          parameters: [
            ShellParameter('what', 'w', 'What to say?', isOptional: true),
            ShellParameter('name', 'n', 'Say privately!', isOptional: true),
          ],
          allowPublicMessage: false,
          allowPrivateMessage: true,
          allowUserAccessList: null)
        ..onEvent.listen(_handleSayCmd)
    ]));

    //::Let's do something as soon as we entered the arena!
    _arena.onEntered.listen((_) {
      print('Entered arena!');
    });
    //::Let's do something when a player enters
    _arena.onPlayerEnter.listen(_handlePlayerEnter);
    //::Let's do something when a player leaves
    _arena.onPlayerLeave.listen(_handlePlayerLeave);
  }

  void _handlePlayerEnter(player) {
    print('Player ${player.name} has entered');
  }

  void _handlePlayerLeave(player) {
    print('Player ${player.name} has left');
  }

  void _handleSayCmd(ShellEvent event) {
    //::Fetch the arguments from the input
    var what = event.arguments['what'];
    var name = event.arguments['name'];

    if (what == null && name == null && event.arguments[''].isNotEmpty) {
      //::If no parameter name(s) was passed in but has some input then map the input to $what
      //::(Example: !say Hello World! will set $what = 'Hello World!')
      what = event.arguments[''];
    }

    if (what == null) {
      _chat.reply(event.message, 'You have nothing to say...');
    } else {
      //::Have something to say
      if (name == null) {
        //::Say it in public
        _chat.send('$what');
      } else {
        //::Finds the first player that matches $name
        var player = _arena.findPlayerByName(name, exact: false);
        if (player != null) {
          //::Send it as private
          _chat.send('/$what', playerId: player.playerId);
        } else {
          //::Send it as remote private
          _chat.send(':$name:$what');
        }
      }
      //::Reply to the owner of $event.message aka the player who executed this cmd
      _chat.reply(event.message, 'Task done! message \'$what\' has been sent!');
    }
  }
}
