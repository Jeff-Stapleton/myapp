import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Event extends StatefulWidget {
  const Event({ Key? key }) : super(key: key);

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.album),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('29 March 2021'),
            trailing: Text('1.8mi'),
          ),
          Expanded (      
            child: Stack(    
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.network('https://images.unsplash.com/photo-1570872626485-d8ffea69f463?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bmlnaHQlMjBjbHVifGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80'),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: new ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(onPressed: (){}, icon: Icon(Icons.money), color: Colors.lightBlue[800]),
                      IconButton(onPressed: (){}, icon: Icon(Icons.rsvp), color: Colors.lightBlue[800]),
                      IconButton(onPressed: (){}, icon: Icon(Icons.share), color: Colors.lightBlue[800]),
                      IconButton(onPressed: (){}, icon: Icon(Icons.comment), color: Colors.lightBlue[800]),
                    ]
                  ),
                )
              ]
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: RichText(
              text: new TextSpan(
                style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  new TextSpan(text: 'Comic Con', style: new TextStyle(fontWeight: FontWeight.bold)),
                  new TextSpan(text: ' '),
                  new TextSpan(text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus semper magna in magna pharetra molestie. Aenean sed bibendum justo.'),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}