import 'package:flutter/material.dart';
import 'storage.dart';
import 'changePassword.dart';
import 'settings.dart';

class NoteScreen extends StatefulWidget {
  final NotEncryptedNotesStorage storage;
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
    _note = note;
  }

  _saveNote() {
    String password = widget.password;
    widget.storage.saveNote(_note, password);
    setState(() {
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
    });
  }

  _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  _changePassword() {
    Navigator.pushReplacementNamed(context, '/changePassword');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(
        backgroundColor: Colors.green,
        title: Text('Tajne notatki')
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green
              ),
              child: Text(
                'Dzień dobry',
                style: TextStyle(
                  color: Colors.white
                ),  
              )
            ),
            ListTile(
              title: Text('Zmień hasło'),
              trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ChangePasswordScreen(storage: PasswordStorage())));
              },
            ),
            ListTile(
              title: Text('Ustawienia'),
              trailing: Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SettingsPage()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Wyloguj się'),
              trailing: Icon(Icons.exit_to_app),
              onTap: () => _logout()
            ),
          ],
        )
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              '$_note',
              style: TextStyle(fontSize: 26.0, color: Colors.pinkAccent)
            ),
            Container(
              child: Column(
                children: [
                  TextField(
                    textAlign: TextAlign.center,
                    onChanged: (String note) {_changeNote(note);},
                    decoration: InputDecoration(
                      hintText: 'Wpisz nową notatkę',
                    ),
                  ),
                  Container(height: 8.0),
                  RaisedButton(
                    child: Text('Zapisz notatkę'),
                    onPressed: _saveNote,
                    color: Colors.green,
                    textColor: Colors.white,
                  )
                ]
              )
            )
            
          ]
        )
      )
    );
  }
}
