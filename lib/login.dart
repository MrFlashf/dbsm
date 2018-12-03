import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
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

  @override
  void initState() {
    super.initState();
    fingerPrint();
  }

  void fingerPrint() async {
    bool fingerprintEnabled = await SettingsStorage().isFingerprintSet();
    var localAuth = new LocalAuthentication();
    var canCheckBiometrics =
      await localAuth.canCheckBiometrics;


    if (fingerprintEnabled && canCheckBiometrics) {
      var didAuthenticate = await localAuth.authenticateWithBiometrics(
        localizedReason: 'Dawaj palucha'
      );
      if (didAuthenticate) {
      var route = MaterialPageRoute(
        builder: (BuildContext context) => NoteScreen(storage: NotesStorage(), password: _password)
      );
      Navigator.of(context).pushReplacement(route);
      }
    }
  }

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
      body: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(50.0),
              child: Text(
                'Zaloguj się',
                style: TextStyle(
                  fontSize: 26.0
                )
              )
            ),
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
