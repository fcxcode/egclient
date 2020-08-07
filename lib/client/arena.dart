import 'dart:async';

import 'package:egclient/client/packets/packets.dart';
import 'package:egclient/client/zone.dart';

part 'arena_data.dart';

class Arena {
  final Zone _zone;

  String _name;
  String get name => _name;

  int _pilotPlayerId;
  Player _pilot;
  Player get pilot => _pilot;
  Player _pilotTarget;
  Player get pilotTarget => _pilotTarget;

  final Map<int, Player> _players = <int, Player>{};
  List<Player> get players => List.unmodifiable(_players.values);
  Player findPlayerById(int id) => _players[id];
  Player findPlayerByName(String name, {bool exact = true}) => exact
      ? _players.values.firstWhere(
          (p) => p.nameLowerCase == name.trim().toLowerCase(),
          orElse: () => null)
      : _players.values.firstWhere(
          (p) => p.nameLowerCase.startsWith(name.trim().toLowerCase()),
          orElse: () => null);

  final Map<int, Team> _teams = <int, Team>{};
  List<Team> get teams => List.unmodifiable(_teams.values);
  Team findTeamById(int id) => _teams[id];

  int get tick => _zone.tick;
  int get elapsed => _zone.elapsed;
  Stream<int> get onTick => _zone.onTick;

  final StreamController<int> _onEntering = StreamController<int>.broadcast();
  Stream<int> get onEntering => _onEntering.stream;
  final StreamController<void> _onEntered = StreamController<void>.broadcast();
  Stream<void> get onEntered => _onEntered.stream;

  final StreamController<Player> _onPlayerEnter =
      StreamController<Player>.broadcast();
  Stream<Player> get onPlayerEnter => _onPlayerEnter.stream;
  final StreamController<Player> _onPlayerLeave =
      StreamController<Player>.broadcast();
  Stream<Player> get onPlayerLeave => _onPlayerLeave.stream;

  Arena(this._zone) {
    _zone.onPacket.listen(_handleOnPacket);
  }

  void enter([String name = '']) {
    _name = name;
    var arenaEnter = ArenaEnter(name);
    _zone.send(arenaEnter.toPacket());
  }

  void target(int playerId) {
    var player = findPlayerById(playerId);
    if (player != null) {
      var target = PlayerTarget(player.playerId);
      _zone.send(target.toPacket());
      _pilotTarget = player;
    }
  }

  void _handleOnPacket(Packet packet) {
    if (packet.type == PacketType.arenaEntering) {
      var arenaEntering = ArenaEntering.fromPacket(packet);
      _pilotPlayerId = arenaEntering.playerId;
      _pilot = Player(_pilotPlayerId, '', '');
      _pilotTarget = _pilot;
      _players.clear();
      _teams.clear();
      _onEntering.add(_pilotPlayerId);
      print('Arena entered (playerId: ${_pilotPlayerId})');
    } else if (packet.type == PacketType.arenaEntered) {
      //var arenaEntered = ArenaEntered.fromPacket(packet);
      _onEntered.add(null);
      print('Arena entered (playerId: ${_pilotPlayerId})');
    } else if (packet.type == PacketType.playerEnter) {
      var playerEnter = PlayerEnter.fromPacket(packet);
      var team = _teams.putIfAbsent(
          playerEnter.teamId, () => Team(playerEnter.teamId));
      var player = _players.putIfAbsent(
          playerEnter.playerId,
          () => Player(
              playerEnter.playerId, playerEnter.name, playerEnter.squad));
      if (_pilotPlayerId == _pilot.playerId) {
        _pilot = player;
        _pilotTarget = player;
      }
      player._team = team;
      player._team._players.add(player);
      _onPlayerEnter.add(player);
      //print('Player ${player.name} has enter ${playerEnter.playerId}');
    } else if (packet.type == PacketType.playerLeave) {
      var playerLeave = PlayerLeave.fromPacket(packet);
      var player = findPlayerById(playerLeave.playerId);
      player._teamOld = player._team;
      player._team._players.remove(player);
      player._team = null;
      _players.remove(player.playerId);
      _onPlayerLeave.add(player);
      //print('Player ${player.name} has left ${playerLeave.playerId}');
    }
  }
}
