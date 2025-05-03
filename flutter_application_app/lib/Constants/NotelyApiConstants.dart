class NotelyApiConstants {

  //Base URL
  static const String baseUrl = "http://localhost/ProgettoFlutterApp/WebServiceApp/Service/v1"; 

  //Common endpoints
  static const String NotepadsEndpoint = "$baseUrl/Notepads"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads
  static const String NoteEndpoint = "$baseUrl/Notes"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes
  static const String UserEndpoint = "$baseUrl/Users"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Users 

  //Final Endpoints =======================================

    //NOTEPAD endpoints
    static const String FETCH_NOTEPAD = NotepadsEndpoint; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads
    static const String CREATE_NOTEPAD = "$NotepadsEndpoint/create"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads/create
    static const String EDIT_NOTEPAD_BODY = "$NotepadsEndpoint/edit-body"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads/edit-body
    static const String DELETE_NOTEPAD = "$NotepadsEndpoint/delete"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notepads/delete

    //NOTE endpoints
    static const String CREATE_NOTE = "$NoteEndpoint/create"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes/create
    static const String EDIT_NOTE_TITLE = "$NoteEndpoint/edit-title"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes/edit-title
    static const String EDIT_NOTE_BODY = "$NoteEndpoint/edit-body"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes/edit-body
    static const String SHARE_NOTE = "$NoteEndpoint/share"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes/share
    static const String DELETE_NOTE = "$NoteEndpoint/delete"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes/delete
    static const String FETCH_NOTES = NoteEndpoint; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Notes


    //USER endpoints
    static const String CHECK_USERNAME = "$UserEndpoint/check-username"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Users/check-username
    static const String AUTH = "$UserEndpoint/auth"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Users/auth
    static const String ADD_USER = "$UserEndpoint/add-user"; // http://localhost/ProgettoFlutterApp/WebSerivceApp/v1/Users/add-user
}
