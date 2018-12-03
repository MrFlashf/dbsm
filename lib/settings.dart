import 'storage.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  bool _isChecked = false;

  void initState() {
    super.initState();
    SettingsStorage().isFingerprintSet().then((bool value) {
      _isChecked = value;
    });
  }

  void onChanged(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void save() {
    SettingsStorage().saveFingerprintOption(_isChecked);
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Zapisano'),
            content: Text('Zapisano ustawienia'),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Ustawienia')
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CheckboxListTile(
              title: Text('Zaloguj odciskiem palca'),
              value: _isChecked,
              secondary: const Icon(Icons.fingerprint),
              onChanged: (bool value) {onChanged(value);}
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text('Zapisz'),
              onPressed: save
            )
          ],
        )
      )
    );
  } 
}
