import 'dart:async';
import 'auth.dart';
import 'cloud_service_config.dart';

/// WebDAV 认证服务
/// WebDAV 使用 HTTP Basic Authentication，配置时已提供用户名密码
/// 不需要传统的登录流程，配置即登录
class WebdavAuthService implements AuthService {
  final CloudServiceConfig config;
  late final StreamController<AuthUser?> _authStateController;
  AuthUser? _currentUser;

  WebdavAuthService(this.config) {
    // 如果配置有效，立即创建虚拟用户
    if (config.valid && config.type == CloudBackendType.webdav) {
      _currentUser = AuthUser(
        id: config.webdavUsername!,
        email: '${config.webdavUsername}@webdav',
      );
    }

    // 创建 StreamController，在监听时立即发送当前用户状态
    _authStateController = StreamController<AuthUser?>.broadcast(
      onListen: () {
        // 当有监听者时，立即发送当前状态
        if (_currentUser != null) {
          _authStateController.add(_currentUser);
        }
      },
    );
  }

  @override
  Stream<AuthUser?> authStateChanges() {
    return _authStateController.stream;
  }

  @override
  Future<AuthUser?> currentUser() async {
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // WebDAV 不支持邮箱登录，直接使用配置的凭据
    throw UnsupportedError('WebDAV does not support email sign in');
  }

  @override
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    throw UnsupportedError('WebDAV does not support sign up');
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    throw UnsupportedError('WebDAV does not support password reset');
  }

  @override
  Future<void> resendEmailVerification({required String email}) async {
    throw UnsupportedError('WebDAV does not support email verification');
  }

  void dispose() {
    _authStateController.close();
  }
}
