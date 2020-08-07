part of 'shell.dart';

final Map<String, StreamController<ShellEvent>> _eventsMap =
    <String, StreamController<ShellEvent>>{};

extension ShellCommandEvent on ShellCommand {
  Stream<ShellEvent> get onEvent {
    if (_eventsMap[id] == null) {
      _eventsMap[id] = StreamController<ShellEvent>.broadcast();
    }
    return _eventsMap[id].stream;
  }
}

class ShellModule {
  final String name;
  final String alias;
  final String description;
  final List<ShellCommand> commands;

  ShellModule(this.name, this.alias, this.description, this.commands);
  ShellModule.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        alias = json['alias'],
        description = json['description'],
        commands = List<ShellCommand>.from(
            json['commands'].map((e) => ShellCommand.fromJson(e)));

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'alias': alias,
      'description': description,
      'commands': commands.map((e) => e.toJson()).toList()
    };
  }
}

class ShellCommand {
  static int _index = 0;

  final String id;
  final String name;
  final String alias;
  final String description;

  final List<ShellParameter> parameters;

  final bool allowPublicMessage;
  final bool allowTeamMessage;
  final bool allowTeamRemoteMessage;
  final bool allowPrivateMessage;
  final bool allowPrivateRemoteMessage;
  final List<String> allowUserAccessList;

  ShellCommand(
    this.name,
    this.alias,
    this.description, {
    this.parameters,
    this.allowUserAccessList,
    this.allowPublicMessage = false,
    this.allowTeamMessage = false,
    this.allowTeamRemoteMessage = false,
    this.allowPrivateMessage = false,
    this.allowPrivateRemoteMessage = false,
  }) : id = '${name}-${alias}-${_index++}';
  ShellCommand.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        alias = json['alias'],
        description = json['description'],
        parameters = List<ShellParameter>.from(
            json['parameters'].map((e) => ShellParameter.fromJson(e)).toList()),
        allowUserAccessList = json['allowUserAccessList'] == null
            ? null
            : List<String>.from(json['allowUserAccessList']),
        allowPublicMessage = json['allowPublicMessage'],
        allowTeamMessage = json['allowTeamMessage'],
        allowTeamRemoteMessage = json['allowTeamRemoteMessage'],
        allowPrivateMessage = json['allowPrivateMessage'],
        allowPrivateRemoteMessage = json['allowPrivateRemoteMessage'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'alias': alias,
      'description': description,
      'parameters': parameters.map((e) => e.toJson()).toList(),
      'allowUserAccessList': allowUserAccessList,
      'allowPublicMessage': allowPublicMessage,
      'allowTeamMessage': allowTeamMessage,
      'allowTeamRemoteMessage': allowTeamRemoteMessage,
      'allowPrivateMessage': allowPrivateMessage,
      'allowPrivateRemoteMessage': allowPrivateRemoteMessage,
    };
  }
}

class ShellParameter {
  final String name;
  final String alias;
  final String description;
  final bool isOptional;

  ShellParameter(this.name, this.alias, this.description,
      {this.isOptional = false});
  ShellParameter.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        alias = json['alias'],
        description = json['description'],
        isOptional = json['isOptional'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'alias': alias,
      'description': description,
      'isOptional': isOptional
    };
  }
}

class ShellEvent {
  final Message message;
  final Map<String, String> arguments;

  int get playerId => message.playerId;
  String get user => message.author;

  ShellEvent(this.message, this.arguments);
  ShellEvent.fromJson(Map<String, dynamic> json)
      : message = Message.fromJson(json['message']),
        arguments = Map<String, String>.from(json['arguments']);

  Map<String, dynamic> toJson() {
    return {'message': message.toJson(), 'arguments': arguments};
  }
}
