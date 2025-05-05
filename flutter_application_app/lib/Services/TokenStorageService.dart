import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Salva il token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Recupera il token
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Elimina il token
  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<void> setMod() async {
    await _storage.write(key: 'mod', value: 'json');
  }

  // Recupera il token
  Future<String?> getMod() async {
    return await _storage.read(key: 'mod');
  }

  // Elimina il token
  Future<void> changeMod() async {
    String? currentMod = await getMod();
    if (currentMod == 'json') {
      await _storage.write(key: 'mod', value: 'xml');
    } else {
      await _storage.write(key: 'mod', value: 'json');
    }
  }


}
