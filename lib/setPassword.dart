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
  bool _loading = false;

  changePassword(String password) {
    _password = password;
  }

  void _savePassword() async {
    _loading = true;
    setState(() {
      _loading = true;
      widget.storage.savePassword(_password);
      Navigator.pushReplacementNamed(context, '/login');
    });
    // _loading = false;
  }

  body() {
    if (_loading) {
      return [
        Center(child: CircularProgressIndicator())
      ];
    } else {
      return [
        TextField(
          textAlign: TextAlign.center,
          obscureText: true,
          onChanged: (String password) {changePassword(password);},
          decoration: InputDecoration(
            hintText: 'Wpisz hasło',
          ),
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: Text('Zapisz hasło'),
          onPressed: _savePassword
        )
      ];
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zarejestruj hasło')
      ),
      body: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: body()
          // <Widget>[
          //   CircularProgressIndicator(),
          //   TextField(
          //     textAlign: TextAlign.center,
          //     obscureText: true,
          //     onChanged: (String password) {changePassword(password);},
          //     decoration: InputDecoration(
          //       hintText: 'Wpisz hasło',
          //     ),
          //   ),
          //   RaisedButton(
          //     color: Theme.of(context).primaryColor,
          //     textColor: Colors.white,
          //     child: Text('Zapisz hasło'),
          //     onPressed: _savePassword
          //   )
          // ]
        )
      )
    );
  }
}
