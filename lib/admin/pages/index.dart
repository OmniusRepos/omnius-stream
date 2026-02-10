import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr/dom.dart' show script;
import 'package:jaspr_router/jaspr_router.dart';

class AdminPage extends StatelessComponent {
  const AdminPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(
        className: 'min-h-screen bg-[#141414] text-white',
        children: [
          // Header
          Header(
              className:
                  'sticky top-0 z-50 bg-[#141414]/80 backdrop-blur-xl border-b border-white/10',
              children: [
                Div(
                    className:
                        'max-w-7xl mx-auto px-6 py-4 flex items-center justify-between',
                    children: [
                      Div(className: 'flex items-center gap-4', children: [
                        Link(
                          to: '/',
                          child: Span(
                              className:
                                  'text-gray-400 hover:text-white text-sm transition-colors',
                              child: Text('\u2190 Back to Site')),
                        ),
                        Div(
                            className: 'w-px h-6 bg-white/10',
                            children: []),
                        H1(
                            className: 'text-xl font-bold text-white',
                            child: Text('Omnius Admin')),
                      ]),
                    ]),
              ]),

          // Login Section
          Div(
              className: 'flex items-center justify-center min-h-[70vh]',
              children: [
                Div(
                    className:
                        'w-full max-w-md p-8 rounded-2xl bg-[#1a1a1a] border border-white/10',
                    children: [
                      Div(className: 'text-center mb-8', children: [
                        Div(
                            className:
                                'inline-flex items-center justify-center w-16 h-16 rounded-full bg-primary-500/10 mb-4',
                            children: [
                              Span(
                                  className: 'text-2xl text-primary-500',
                                  child: Text('\u{1f6e1}')),
                            ]),
                        H2(
                            className: 'text-2xl font-bold text-white mb-2',
                            child: Text('Admin Access')),
                        P(
                            className: 'text-gray-400 text-sm',
                            child:
                                Text('Enter your admin secret to continue')),
                      ]),
                      Div(className: 'space-y-4', children: [
                        Div(children: [
                          Label(
                              className:
                                  'block text-sm font-medium text-gray-300 mb-2',
                              child: Text('Admin Secret')),
                          Input(
                              type: 'password',
                              className:
                                  'w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-primary-500 transition-colors',
                              attributes: {
                                'id': 'admin-secret-input',
                                'placeholder': 'Enter admin secret...',
                              }),
                        ]),
                        Div(
                            id: 'login-error',
                            className: 'hidden',
                            children: [
                              P(
                                  className:
                                      'text-red-400 text-sm bg-red-500/10 rounded-lg px-4 py-2',
                                  child: Text(
                                      'Invalid admin secret. Please try again.')),
                            ]),
                        Button(
                            className:
                                'w-full px-4 py-3 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                            attributes: {'id': 'admin-login-btn'},
                            child: Text('Sign In')),
                      ]),
                    ]),
              ]),

          // Login Script
          script(content: '''
(function() {
  // Auto-login check: if already authenticated, redirect to customers
  fetch('/api/admin/stats', { credentials: 'same-origin' }).then(function(res) {
    if (res.ok) {
      window.location.href = '/admin/customers';
    }
  }).catch(function() {});

  function attemptLogin() {
    var input = document.getElementById('admin-secret-input');
    var secret = input ? input.value.trim() : '';
    if (!secret) return;

    fetch('/api/admin/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'same-origin',
      body: JSON.stringify({ secret: secret })
    }).then(function(res) {
      if (res.ok) {
        window.location.href = '/admin/customers';
      } else {
        document.getElementById('login-error').classList.remove('hidden');
      }
    }).catch(function() {
      document.getElementById('login-error').classList.remove('hidden');
    });
  }

  var loginBtn = document.getElementById('admin-login-btn');
  if (loginBtn) loginBtn.addEventListener('click', attemptLogin);

  var secretInput = document.getElementById('admin-secret-input');
  if (secretInput) {
    secretInput.addEventListener('keydown', function(e) {
      if (e.key === 'Enter') attemptLogin();
    });
  }
})();
          '''),
        ]);
  }
}
