import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:password/password.dart';

class PasswordStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _passwordFile async {
    final path = await _localPath;
    return File('$path/tu_nie_ma_hasla.txt');
  }

  void savePassword(String password) async {
    final file = await _passwordFile;
    String hash = Password.hash(password, PBKDF2());
    file.writeAsString('$hash');
  }

  Future<bool> checkIfPasswordExists() async {
    try {
      final file = await _passwordFile;
      String passwordHash = await file.readAsString();
      return passwordHash.length > 0;
    } catch(e) {
      return false;
    }
  }

  void resetPassword() async {
    final passwordFile = await _passwordFile;
    passwordFile.deleteSync();
  }

  Future<bool> checkPassword(String password) async {
    try {
      final passFile = await _passwordFile;
      String hash = await passFile.readAsString();

      return Password.verify(password, hash);
    } catch(e) {
      return false;
    }
  } 

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      var passwordCorrect = await checkPassword(oldPassword);
      if (!passwordCorrect) {
        return false;
      }

      savePassword(newPassword);
      return true;

    } catch(e) {
      return false;
    }
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
