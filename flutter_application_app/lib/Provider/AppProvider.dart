import 'package:flutter/material.dart';
import 'package:flutter_application_app/Services/ApiService.dart';
import 'package:flutter_application_app/Constants/NotelyApiConstants.dart';

class AppProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  AppProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _apiService.ready;
  }

  // Variabili per lo stato
  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = true;
  bool _hasError = false;

  List<Map<String, dynamic>> get notes => _notes;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  // ==================== NOTEPAD ====================

  Future<List<dynamic>?> fetchNotepads({String? mod, int? userID}) async {
    print("Fetching notepads...");
    print("Using Endpoint: ${NotelyApiConstants.FETCH_NOTEPAD}");
    final response = await _apiService.getRequest(NotelyApiConstants.FETCH_NOTEPAD + "?mod=$mod");
    if (response != null && response['success'] == 'true') {
      return response['notepads'];
    }
    return null;
  }

  Future<bool> createNotepad(String title) async {
    print("Creating notepad with title: $title");
    print("Using Endpoint: ${NotelyApiConstants.CREATE_NOTEPAD}");
    final response = await _apiService.postRequest(NotelyApiConstants.CREATE_NOTEPAD, {"title": title});
    return response != null && response['success'] == 'true';
  }

  Future<bool> editNotepadBody(int idNotepad, String newBody) async {
    print("Editing notepad with ID: $idNotepad");
    print("Using Endpoint: ${NotelyApiConstants.EDIT_NOTEPAD_BODY}");
    final response = await _apiService.putRequest(NotelyApiConstants.EDIT_NOTEPAD_BODY, {"id": idNotepad, "body": newBody});
    return response != null && response['success'] == 'true';
  }

  Future<bool> deleteNotepad(int idNotepad) async {
    print("Deleting notepad with ID: $idNotepad");
    print("Using Endpoint: ${NotelyApiConstants.DELETE_NOTEPAD}");
    final response = await _apiService.deleteRequest("${NotelyApiConstants.DELETE_NOTEPAD}/$idNotepad");
    return response != null && response['success'] == 'true';
  }

  // ==================== NOTE ====================

  Future<bool> createNote(int idNotepad, String title, String body) async {
    print("Creating note in notepad with ID: $idNotepad");
    print("Using Endpoint: ${NotelyApiConstants.CREATE_NOTE}");
    final response = await _apiService.postRequest(NotelyApiConstants.CREATE_NOTE, {"id_notepad": idNotepad, "title": title, "body": body});
    return response != null && response['success'] == 'true';
  }

  Future<bool> editNoteTitle(int idNote, String newTitle) async {
    print("Editing note with ID: $idNote");
    print("Using Endpoint: ${NotelyApiConstants.EDIT_NOTE_TITLE}");
    final response = await _apiService.patchRequest(NotelyApiConstants.EDIT_NOTE_TITLE, {"id": idNote, "title": newTitle});
    return response != null && response['success'] == 'true';
  }

  Future<bool> editNoteBody(int idNote, String newBody) async {
    print("Editing note with ID: $idNote");
    print("Using Endpoint: ${NotelyApiConstants.EDIT_NOTE_BODY}");
    final response = await _apiService.patchRequest(NotelyApiConstants.EDIT_NOTE_BODY, {"id": idNote, "body": newBody});
    return response != null && response['success'] == 'true';
  }

  Future<bool> shareNote(int idNote, String username) async {
    print("Sharing note with ID: $idNote to user: $username");
    print("Using Endpoint: ${NotelyApiConstants.SHARE_NOTE}");
    final response = await _apiService.postRequest(NotelyApiConstants.SHARE_NOTE, {"id_note": idNote, "username": username});
    return response != null && response['success'] == 'true';
  }

  Future<bool> deleteNote(int idNote) async {
    print("Deleting note with ID: $idNote");
    print("Using Endpoint: ${NotelyApiConstants.DELETE_NOTE}");
    final response = await _apiService.deleteRequest("${NotelyApiConstants.DELETE_NOTE}/$idNote");
    return response != null && response['success'] == 'true';
  }

  Future<void> fetchNotes({int? idNotepad, String? mod}) async {
  _isLoading = true;
  _hasError = false;
  notifyListeners();

  try {
    String url = NotelyApiConstants.NoteEndpoint;

    if (idNotepad != null) {
      url += "?id_notepad=$idNotepad";
    }
    if (mod != null) {
      url += (idNotepad != null ? "&" : "?") + "mod=$mod";
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
