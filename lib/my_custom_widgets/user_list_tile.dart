import 'package:flutter/material.dart';

class UserListTile extends StatelessWidget {
  final String name;
  final String email;
  final int id;
  final Function onTap;
  UserListTile({
    this.name,
    this.id,
    this.email,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.5,
      child: ListTile(
        onTap: onTap,
        leading: Hero(
          tag: '$id',
          child: CircleAvatar(
            child: Text(_getAvatarText()),
          ),
        ),
        title: Text(name),
        subtitle: Text(email),
      ),
    );
  }

  String _getAvatarText() {
    int spaceIndex = name.indexOf(' ');
    String shortcut = name[0] + name[spaceIndex + 1];
    return shortcut;
  }

  
}
