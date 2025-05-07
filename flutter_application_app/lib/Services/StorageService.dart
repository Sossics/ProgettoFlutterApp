import 'package:flutter_application_app/Constants/HTTPmode.dart';
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

  Future<void> setMod(HTTPMode mode) async {
    await _storage.write(key: 'mod', value: mode.value);
  }

  Future<void> initStorage() async {
    await _storage.write(key: 'mod', value: HTTPMode.json.value);
  }

  Future<HTTPMode?> getMod() async {
    final raw = await _storage.read(key: 'mod');
    if (raw == null) return null;

    try {
      return HTTPModeExtension.fromString(raw);
    } catch (_) {
      return null;
    }
  }

  // Elimina il token
  Future<void> changeMod() async {
    final currentMod = await getMod();
    final newMod = (currentMod == HTTPMode.json) ? HTTPMode.xml : HTTPMode.json;
    await setMod(newMod);
  }
}
