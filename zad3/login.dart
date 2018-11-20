import 'package:flutter/material.dart';
import 'storage.dart';
import 'note.dart';

class LoginScreen extends StatefulWidget {
  final PasswordStorage storage;

  LoginScreen({Key key, @required this.storage}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _password;

  _changePassword(String password) {
    _password = password;
  }

  _checkPassword() async {
    widget.storage.checkPassword(_password)
      .then((bool value) {
        if (value) {
          var route = MaterialPageRoute(
            builder: (BuildContext context) => NoteScreen(storage: NotesStorage(), password: _password)
          );
          Navigator.of(context).pushReplacement(route);
        } else {
          setState(() {
            _password = '';          
          });
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login screen')
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (String password) {_changePassword(password);},
                decoration: InputDecoration(
                  hintText: 'Wpisz hasło',
                ),
              ),
              RaisedButton(
                child: Text('Zaloguj'),
                onPressed: _checkPassword
              )
            ]
          )
        )
      )
    );
  }

}
