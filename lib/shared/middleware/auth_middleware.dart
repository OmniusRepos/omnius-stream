/// Cookie-based session middleware for protected routes.
/// Checks for a valid session cookie and attaches user info to the request.
class AuthMiddleware {
  static const String sessionCookieName = 'omnius_session';

  /// Extract a specific cookie value from the Cookie header
  static String? _extractCookie(String cookieHeader, String name) {
    final cookies = cookieHeader.split(';');
    for (final cookie in cookies) {
      final trimmed = cookie.trim();
      if (trimmed.startsWith('$name=')) {
        return Uri.decodeComponent(trimmed.substring(name.length + 1));
      }
    }
    return null;
  }

  /// Create a session cookie value
  static String createSessionValue(int userId, String email) {
    return '$userId:$email';
  }

  /// Parse user ID from session cookie
  static int? getUserId(String? cookieHeader) {
    if (cookieHeader == null) return null;
    final token = _extractCookie(cookieHeader, sessionCookieName);
    if (token == null) return null;
    final parts = token.split(':');
    if (parts.isEmpty) return null;
    return int.tryParse(parts[0]);
  }

  /// Create Set-Cookie header for session
  static String createSetCookieHeader(int userId, String email) {
    final value = Uri.encodeComponent(createSessionValue(userId, email));
    return '$sessionCookieName=$value; Path=/; HttpOnly; SameSite=Lax; Max-Age=604800';
  }

  /// Create Set-Cookie header to clear session
  static String createClearCookieHeader() {
    return '$sessionCookieName=; Path=/; HttpOnly; SameSite=Lax; Max-Age=0';
  }
}
