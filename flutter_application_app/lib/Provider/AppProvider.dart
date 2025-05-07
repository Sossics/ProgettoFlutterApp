import 'package:flutter/material.dart';
import 'package:flutter_application_app/Services/ApiService.dart';
import 'package:flutter_application_app/Constants/NotelyApiConstants.dart';
import 'package:flutter_application_app/Services/StorageService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AppProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _StorageService = StorageService();

  String? _mod;
  String? _token;
  int _userID = -1;

  AppProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _token = await _StorageService.getToken();
    
    if (_token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(_token!);
      _userID = decodedToken['uid'] ?? -1;
    }
    await _apiService.ready;
  }

  // Variabili per lo stato
  List<Map<String, dynamic>> _notes = [];
  List<Map<String, dynamic>> _notepads = [];

  bool _isLoading = true;
  bool _hasError = false;

  List<Map<String, dynamic>> get notes => _notes;
  List<Map<String, dynamic>> get notepads => _notepads;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  // ==================== NOTEPAD ====================

  Future<void> fetchNotepads() async {
    _initialize();
    _isLoading = true;
    _hasError = false;
    notifyListeners();
    _mod = await _StorageService.getMod();

    try {
      print("Fetching notepads...");
      print("Using Endpoint: ${NotelyApiConstants.FETCH_NOTEPAD}");

      final response = await _apiService.getRequest(
        "${NotelyApiConstants.FETCH_NOTEPAD}?mod=$_mod&id_user=$_userID",
      );

      if (response != null && response['success'] == 'true') {
        var data = response['notepads'];

        if (data is List) {
          _notepads = List<Map<String, dynamic>>.from(data);
        } else if (data is Map<String, dynamic>) {
          _notepads = [data];
        } else {
          _notepads = [];
        }
      } else {
        _hasError = true;
      }
    } catch (e) {
      print("Errore in fetchNotepads: $e");
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createNotepad(String title, String description) async {
    print("Creating notepad with title: $title");
    print("Using Endpoint: ${NotelyApiConstants.CREATE_NOTEPAD}");
    final response = await _apiService.postRequest(
      NotelyApiConstants.CREATE_NOTEPAD,
      {"title": title, "mod": _mod, "id_user": _userID, "description": description},
    );
    return response != null && response['success'] == 'true';
  }

  Future<bool> editNotepadBody(int idNotepad, String newBody) async {
    print("Editing notepad with ID: $idNotepad");
    print("Using Endpoint: ${NotelyApiConstants.EDIT_NOTEPAD_BODY}");
    final response = await _apiService.putRequest(
      NotelyApiConstants.EDIT_NOTEPAD_BODY,
      {"id": idNotepad, "body": newBody},
    );
    return response != null && response['success'] == 'true';
  }

  Future<bool> deleteNotepad(int idNotepad) async {
    print("Deleting notepad with ID: $idNotepad");
    print("Using Endpoint: ${NotelyApiConstants.DELETE_NOTEPAD}");
    final response = await _apiService.deleteRequest(
      "${NotelyApiConstants.DELETE_NOTEPAD}/$idNotepad",
    );
    return response != null && response['success'] == 'true';
  }

  // ==================== NOTE ====================

  Future<bool> createNote(int idNotepad, String title, String body) async {
    print("Creating note in notepad with ID: $idNotepad");
    print("Using Endpoint: ${NotelyApiConstants.CREATE_NOTE}");
    final response = await _apiService.postRequest(
      NotelyApiConstants.CREATE_NOTE,
      {"id_notepad": idNotepad, "title": title, "body": body, "mod": _mod},
    );
    return response != null && response['success'] == 'true';
  }

  Future<bool> editNoteTitle(int idNote, String newTitle) async {
    _initialize();
    _mod = await _StorageService.getMod();

    print("Editing note with ID: $idNote");
    print("Using Endpoint: ${NotelyApiConstants.EDIT_NOTE_TITLE}");
    final response = await _apiService.patchRequest(
      NotelyApiConstants.EDIT_NOTE_TITLE,
      {"id_note": idNote, "title": newTitle, "mod": _mod},
    );
    return (response != null && response['success'] == 'true');
  }

  Future<bool> editNoteBody(int idNote, String newBody) async {
    _initialize();
    _mod = await _StorageService.getMod();

    print("Editing note with ID: $idNote");
    print("Using Endpoint: ${NotelyApiConstants.EDIT_NOTE_BODY}");
    final response = await _apiService.patchRequest(
      NotelyApiConstants.EDIT_NOTE_BODY,
      {"id_note": idNote, "body": newBody, "mod": _mod},
    );
    return (response != null && response['success'] == 'true');
  }

  Future<bool> shareNote(int idNote, String username) async {
    print("Sharing note with ID: $idNote to user: $username");
    print("Using Endpoint: ${NotelyApiConstants.SHARE_NOTE}");
    final response = await _apiService.patchRequest(
      NotelyApiConstants.SHARE_NOTE,
      {"id_note": idNote, "username": username},
    );
    return response != null && response['success'] == 'true';
  }

  Future<bool> deleteNote(int idNote) async {
    print("Deleting note with ID: $idNote");
    print("Using Endpoint: ${NotelyApiConstants.DELETE_NOTE}");
    final response = await _apiService.deleteRequest(
      "${NotelyApiConstants.DELETE_NOTE}/$idNote",
    );
    return response != null && response['success'] == 'true';
  }

  Future<void> fetchNotes({int? idNotepad}) async {
    _initialize();
    _isLoading = true;
    _hasError = false;
    notifyListeners();
    _mod = await _StorageService.getMod();


    try {
      String url = NotelyApiConstants.NoteEndpoint;

      if (idNotepad != null) {
        url += "?id_notepad=$idNotepad";
      }
      if (_mod != null) {
        url += (idNotepad != null ? "&" : "?") + "mod=$_mod";
      }

      final response = await _apiService.getRequest(url);

      if (response != null && response['success'] == 'true') {
        var notesData = response['notes']['Note'];

        if (notesData is List) {
          _notes = List<Map<String, dynamic>>.from(notesData);
        } else if (notesData is Map<String, dynamic>) {
          _notes = [notesData];
        } else {
          _notes = [];
        }
      } else {
        _hasError = true;
      }
    } catch (e) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }
}
