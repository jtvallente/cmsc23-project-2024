import 'package:flutter/material.dart';

class StreamListTile extends StatefulWidget {
  final Color color;
  final Widget leading;
  final Widget title;
  final Widget trailing;
  final Widget modal;

  const StreamListTile(
      {required this.color,
      required this.modal,
      required this.leading,
      required this.title,
      required this.trailing,
      super.key});

  @override
  State<StreamListTile> createState() => _StreamListTileState();
}

class _StreamListTileState extends State<StreamListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      surfaceTintColor: widget.color,
      child: ListTile(
          onTap: () {
            showDialog(context: context, builder: (context) => widget.modal);
          },
          title: widget.title,
          leading: widget.leading,
          trailing: widget.trailing),
    );
  }
}
