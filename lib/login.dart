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
  String _error;

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
            _error = 'Hasło niepoprawne';
          });
        }
    });
  }

  _resetPassword() async {
    widget.storage.resetPassword();
    NotesStorage().deleteNote();
    Navigator.pushReplacementNamed(context, '/setPassword');
  }

  _showError() {
    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_error',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
              ),
            )
          ]
        )
      );
    } else {
      return Offstage(
        offstage: true,
        child: Text(
          ''
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zaloguj się')
      ),
      body: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (String password) {_changePassword(password);},
              decoration: InputDecoration(
                hintText: 'Wpisz hasło',
              ),
            ),
            _showError(),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text('Zaloguj'),
              onPressed: _checkPassword
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Text(
                      'Nie pamiętam hasła',
                    ),
                    onTap: () { _resetPassword(); }
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
