import 'package:flutter/material.dart';
import 'package:myapp/models/name.model.dart';
import 'package:myapp/services/name.service.dart';

class NameTile extends StatefulWidget {
  final NameModel name;
  TextStyle textStyle = TextStyle(fontSize: 18.0);

  NameTile({
    required this.name, 
    this.textStyle = const TextStyle(fontSize: 18.0)
  });

  @override
  _NameTileState createState() => _NameTileState();
}

class _NameTileState extends State<NameTile> {
  NameService nameService = NameService.instance;
  
  @override
  Widget build(BuildContext context) {
    return ListTile(

      title: Text(
        widget.name.name,
        style: widget.textStyle,
      ),

      trailing: Icon(
        widget.name.liked ? Icons.favorite : Icons.favorite_border,
        color: widget.name.liked ? Colors.red : null,
      ),

      onTap: () {
        setState(() {
          if (widget.name.liked) {
            widget.name.liked = false;
            nameService.unsaveName(widget.name);
          } else {
            widget.name.liked = true;
            nameService.saveName(widget.name);
          }
        });
      },

    );
  }
}