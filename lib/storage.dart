import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:password/password.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasswordStorage {
  final storage = new FlutterSecureStorage();

  void savePassword(String password) async {
    String hash = Password.hash(password, PBKDF2());

    await storage.write(key: 'password', value: hash);
  }

  Future<bool> checkIfPasswordExists() async {
    var password = await storage.read(key: 'password');
    print(password);
  }

  void resetPassword() async {
    storage.delete(key: 'password');
  }

  Future<bool> checkPassword(String password) async {
    String hash = await storage.read(key: 'password');

    return Password.verify(password, hash);
  } 

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    var isPasswordCorrect = await checkPassword(oldPassword);

    if (!isPasswordCorrect) {
      return false;
    }

    savePassword(newPassword);
    return true;
  }
}

class NotesStorage {
  final storage = new FlutterSecureStorage();

  void saveNote(String note, String password) async {
    storage.write(key: 'note', value: note);
  }

  Future<String> getNote(String password) async {
    String note = await storage.read(key: 'note');

    return note;
  }

  void deleteNote() async {
    storage.delete(key: 'note');
  }

}

class NotEncryptedNotesStorage {
   Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _noteFile async {
    final path = await _localPath;
    return File('$path/note.txt');
  }

  void saveNote(String note, String password) async {
    final file = await _noteFile;
    file.writeAsString('$note');
  }

  Future<String> getNote(String password) async {
    try {
      final file = await _noteFile;
      String note = await file.readAsString();

      return note;
    } catch(e) {
      return "Brak notatek";
    }
  }

  void deleteNote() async {
    final file = await _noteFile;

    file.delete();
  }
}

class NotesStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _noteFile async {
    final path = await _localPath;
    return File('$path/note.txt');
  }

  Future<File> get _noteSaltFile async {
    final path = await _localPath;
    return File('$path/noteSugar.txt');
  }

  void saveNote(String note, String password) async {
    final file = await _noteFile;
    final saltFile = await _noteSaltFile;
    final cryptor = new PlatformStringCryptor();

    final String salt = await cryptor.generateSalt();
    final String key = await cryptor.generateKeyFromPassword(password, salt);

    final String encrypted = await cryptor.encrypt(note, key);

    saltFile.writeAsStringSync(salt);
    file.writeAsString('$encrypted');
  }

  Future<String> getNote(String password) async {
    try {
      final file = await _noteFile;
      final saltFile = await _noteSaltFile;
      final cryptor = new PlatformStringCryptor();

      String salt = await saltFile.readAsString();
      String encrypted = await file.readAsString();

      String key = await cryptor.generateKeyFromPassword(password, salt);

      String idk = await cryptor.decrypt(encrypted, key);

      return idk;
    } catch(e) {
      return "Brak notatek";
    }
  }

  void deleteNote() async {
    final file = await _noteFile;
    final saltFile = await _noteSaltFile;
    

    file.delete();
    saltFile.delete();
  }
}
