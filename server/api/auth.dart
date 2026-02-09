import 'package:duxt/server.dart';
import 'package:duxt_orm/duxt_orm.dart';
import 'package:omnius_stream/models/user.dart';
import 'package:omnius_stream/shared/middleware/auth_middleware.dart';

void registerAuthRoutes(DuxtServer server) {
  final users = Model<User>();

  // POST /api/auth/register
  server.post('/api/auth/register', (req) async {
    final body = req.body as Map<String, dynamic>?;
    if (body == null) {
      return json({'error': 'Body required'}, statusCode: 400);
    }

    final email = (body['email'] as String?)?.trim().toLowerCase();
    final name = (body['name'] as String?)?.trim();
    final password = body['password'] as String?;
    final confirmPassword = body['confirm_password'] as String?;

    if (email == null || email.isEmpty) {
      return json({'error': 'Email is required'}, statusCode: 400);
    }
    if (name == null || name.isEmpty) {
      return json({'error': 'Name is required'}, statusCode: 400);
    }
    if (password == null || password.length < 8) {
      return json({'error': 'Password must be at least 8 characters'},
          statusCode: 400);
    }
    if (password != confirmPassword) {
      return json({'error': 'Passwords do not match'}, statusCode: 400);
    }

    // Check if email already exists
    final existing = await users.where('email', email).get();
    if (existing.isNotEmpty) {
      return json({'error': 'Email already registered'}, statusCode: 409);
    }

    // Create user
    final user = User(
      email: email,
      name: name,
      password_hash: User.hashPassword(password),
      is_active: true,
    );
    await user.save();

    // Set session cookie
    final setCookie =
        AuthMiddleware.createSetCookieHeader(user.id as int, email);

    return json(
      {'user': user.toJson(), 'message': 'Registration successful'},
      statusCode: 201,
      headers: {'Set-Cookie': setCookie},
    );
  });

  // POST /api/auth/login
  server.post('/api/auth/login', (req) async {
    final body = req.body as Map<String, dynamic>?;
    if (body == null) {
      return json({'error': 'Body required'}, statusCode: 400);
    }

    final email = (body['email'] as String?)?.trim().toLowerCase();
    final password = body['password'] as String?;

    if (email == null || email.isEmpty || password == null) {
      return json({'error': 'Email and password are required'},
          statusCode: 400);
    }

    // Find user by email
    final results = await users.where('email', email).get();
    if (results.isEmpty) {
      return json({'error': 'Invalid email or password'}, statusCode: 401);
    }

    final user = results.first;
    if (!user.verifyPassword(password)) {
      return json({'error': 'Invalid email or password'}, statusCode: 401);
    }

    if (user.is_active != true) {
      return json({'error': 'Account is deactivated'}, statusCode: 403);
    }

    // Set session cookie
    final setCookie =
        AuthMiddleware.createSetCookieHeader(user.id as int, email);

    return json(
      {'user': user.toJson(), 'message': 'Login successful'},
      headers: {'Set-Cookie': setCookie},
    );
  });

  // GET /api/auth/logout
  server.get('/api/auth/logout', (req) async {
    final clearCookie = AuthMiddleware.createClearCookieHeader();
    return json({'message': 'Logged out'},
        statusCode: 302,
        headers: {'Set-Cookie': clearCookie, 'Location': '/'});
  });

  // GET /api/auth/me — returns current user info
  server.get('/api/auth/me', (req) async {
    final userId =
        AuthMiddleware.getUserId(req.headers['cookie']);
    if (userId == null) {
      return json({'error': 'Not authenticated'}, statusCode: 401);
    }

    final user = await users.find(userId);
    if (user == null) {
      return json({'error': 'User not found'}, statusCode: 404);
    }

    return json({'user': user.toJson()});
  });
}
