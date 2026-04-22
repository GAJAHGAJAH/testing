import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/services/secure_storage.dart';
import '../../../../core/constants/api_constants.dart';

enum AuthStatus { 
  initial, 
  loading, 
  authenticated, 
  unauthenticated, 
  emailNotVerified, 
  error 
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthStatus _status = AuthStatus.initial;
  User? _firebaseUser;
  String? _backendToken;
  String? _errorMessage;
  String? _tempEmail, _tempPassword;

  // Getters
  AuthStatus get status => _status;
  User? get firebaseUser => _firebaseUser;
  String? get backendToken => _backendToken;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  // Helper Methods
  void _setLoading() { 
    _status = AuthStatus.loading; 
    _errorMessage = null; 
    notifyListeners(); 
  }

  void _setError(String msg) { 
    _status = AuthStatus.error; 
    _errorMessage = msg; 
    notifyListeners(); 
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar.';
      case 'user-not-found':
        return 'Akun tidak ditemukan.';
      case 'wrong-password':
        return 'Password salah.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Password minimal 6 karakter.';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';
      default:
        return 'Terjadi kesalahan.';
    }
  }

  // REGISTER
  Future<bool> register({
    required String name, 
    required String email, 
    required String password
  }) async {
    _setLoading();
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      _firebaseUser = cred.user;
      await _firebaseUser?.updateDisplayName(name);
      await _firebaseUser?.sendEmailVerification();
      _tempEmail = email; 
      _tempPassword = password;
      _status = AuthStatus.emailNotVerified;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) { 
      _setError(_mapFirebaseError(e.code)); 
      return false; 
    }
  }

  // VERIFY EMAIL & SEND TOKEN TO BACKEND
  Future<bool> _verifyTokenToBackend() async {
    try {
      final firebaseToken = await _firebaseUser?.getIdToken();
      if (firebaseToken == null) return false;
      
      final res = await DioClient.instance.post(
        ApiConstants.verifyToken, 
        data: {'firebase_token': firebaseToken}
      );
      
      final data = res.data['data'] as Map<String, dynamic>;
      _backendToken = data['access_token'] as String;
      await SecureStorageService.saveToken(_backendToken!);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Gagal verifikasi token: $e');
      return false;
    }
  }

  // LOGIN AFTER EMAIL VERIFIED
  Future<bool> loginAfterEmailVerification() async {
    _setLoading();
    
    // Validasi null
    if (_tempEmail == null || _tempPassword == null) {
      _setError('Session expired, silakan login ulang');
      return false;
    }
    
    await _firebaseUser?.reload();
    _firebaseUser = _auth.currentUser;
    
    if (!(_firebaseUser?.emailVerified ?? false)) { 
      _status = AuthStatus.emailNotVerified; 
      return false; 
    }
    
    final cred = await _auth.signInWithEmailAndPassword(
      email: _tempEmail!, 
      password: _tempPassword!
    );
    _firebaseUser = cred.user; 
    _tempEmail = null; 
    _tempPassword = null;
    return await _verifyTokenToBackend();
  }

  // LOGIN EMAIL
  Future<bool> loginWithEmail({
    required String email, 
    required String password
  }) async {
    _setLoading();
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      _firebaseUser = cred.user;
      
      if (!(_firebaseUser?.emailVerified ?? false)) { 
        _status = AuthStatus.emailNotVerified; 
        return false; 
      }
      return await _verifyTokenToBackend();
    } on FirebaseAuthException catch (e) { 
      _setError(_mapFirebaseError(e.code)); 
      return false; 
    }
  }

  // LOGIN GOOGLE
  Future<bool> loginWithGoogle() async {
    _setLoading();
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) { 
        _setError('Login dibatalkan'); 
        return false; 
      }
      
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, 
        idToken: googleAuth.idToken
      );
      final userCred = await _auth.signInWithCredential(credential);
      _firebaseUser = userCred.user;
      return await _verifyTokenToBackend();
    } catch (e) { 
      _setError('Gagal login Google: $e'); 
      return false; 
    }
  }

  // RESEND & CHECK
  Future<void> resendVerificationEmail() async {
    await _firebaseUser?.sendEmailVerification();
  }

  Future<bool> checkEmailVerified() async {
    await _firebaseUser?.reload(); 
    _firebaseUser = _auth.currentUser;
    
    if (_firebaseUser?.emailVerified ?? false) {
      return await _verifyTokenToBackend();
    }
    return false;
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut(); 
    await _googleSignIn.signOut();
    await SecureStorageService.clearAll();
    _firebaseUser = null; 
    _backendToken = null; 
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}