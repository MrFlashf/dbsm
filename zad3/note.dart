import 'package:flutter/material.dart';
import 'storage.dart';

class NoteScreen extends StatefulWidget {
  final NotesStorage storage;
  final String password;

  NoteScreen({Key key, this.storage, this.password}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  String _note = '';

  void initState() {
    String password = widget.password;

    super.initState();
    widget.storage.getNote(password).then((String note) {
      setState(() {
        _note = note;
      });
    });
  }

  _changeNote(note) {
    setState(() {
      _note = note;
    });
  }

  _saveNote() {
    String password = widget.password;
    widget.storage.saveNote(_note, password);
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Zmieniono notatkę'),
        content: Text('Nowa notatka jest bardzo bezpieczna!'),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  _changePassword() {
    Navigator.pushReplacementNamed(context, '/changePassword');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tajne notatki'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_box),
            onPressed: logout
          )
        ]
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_note',
                style: TextStyle(fontSize: 26.0, color: Colors.pinkAccent)
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (String note) {_changeNote(note);},
                decoration: InputDecoration(
                  hintText: 'Wpisz nową notatkę',
                ),
              ),
              RaisedButton(
                child: Text('Zapisz notatkę'),
                onPressed: _saveNote
              ),
              RaisedButton(
                child: Text('Zmień hasło'),
                onPressed: _changePassword
              )
            ]
          )
        )
      )
    );
  }
}
