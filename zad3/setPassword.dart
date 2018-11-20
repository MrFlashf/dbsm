import 'package:flutter/material.dart';
import 'storage.dart';

class SetPasswordScreen extends StatefulWidget {
  final PasswordStorage storage;

  SetPasswordScreen({Key key, @required this.storage}) : super(key: key);

  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}


class _SetPasswordScreenState extends State<SetPasswordScreen> {
  String _password;

  changePassword(String password) {
    _password = password;
  }

  void _savePassword() async {
    widget.storage.savePassword(_password);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wpisz hasło')
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (String password) {changePassword(password);},
                decoration: InputDecoration(
                  hintText: 'Wpisz nowe hasło',
                ),
              ),
              RaisedButton(
                child: Text('Zapisz hasło'),
                onPressed: _savePassword
              )
            ]
          )
        )
      )
    );
  }
}
