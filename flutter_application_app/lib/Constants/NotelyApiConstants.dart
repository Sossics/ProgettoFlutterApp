class NotelyApiConstants {

  //Base URL
  static const String baseUrl = "http://127.0.0.1/ProgettoFlutterApp/WebServiceApp/Service/v1"; 

  //Common endpoints
  static const String NotepadsEndpoint = "$baseUrl/Notepads"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads
  static const String NoteEndpoint = "$baseUrl/Notes"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes
  static const String UserEndpoint = "$baseUrl/Users"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Users 

  //Final Endpoints =======================================

    //NOTEPAD endpoints
    static const String CREATE_NOTEPAD = "$NotepadsEndpoint/create"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads/create
    static const String EDIT_NOTEPAD_TITLE = "$NotepadsEndpoint/edit-title"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads/edit-title
    static const String EDIT_NOTEPAD_BODY = "$NotepadsEndpoint/edit-body"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads/edit-body
    static const String DELETE_NOTEPAD = "$NotepadsEndpoint/delete"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads/delete
    static const String FETCH_NOTEPAD = NotepadsEndpoint; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads
    static const String FETCH_NOTEPAD_BY_ID = "$NotepadsEndpoint/fetch-by-id"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads/fetch-by-id
    static const String SHARE_NOTEPAD = "$NotepadsEndpoint/share"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads/share

    //NOTE endpoints
    static const String CREATE_NOTE = "$NoteEndpoint/create"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes/create
    static const String EDIT_NOTE_TITLE = "$NoteEndpoint/edit-title"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes/edit-title
    static const String EDIT_NOTE_BODY = "$NoteEndpoint/edit-body"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes/edit-body
    static const String DELETE_NOTE = "$NoteEndpoint/delete"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes/delete
    static const String FETCH_NOTES = NoteEndpoint; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes
    static const String FETCH_NOTE_BY_ID = "$NoteEndpoint/fetch-by-id"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes/fetch-by-id
    static const String SHARE_NOTE = "$NoteEndpoint/share"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes/share
    static const String UNSHARE_NOTE = "$NoteEndpoint/unshare"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes/unshare


    //USER endpoints
    static const String CHECK_USERNAME = "$UserEndpoint/check-username"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Users/check-username
    static const String AUTH = "$UserEndpoint/auth"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Users/auth

    static const String FETCH_USER = "$UserEndpoint"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Users/add-user
    static const String UPDATE_USER = "$UserEndpoint/update"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Users/update
    static const String DELETE_USER = "$UserEndpoint/delete"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Users/delete

}
