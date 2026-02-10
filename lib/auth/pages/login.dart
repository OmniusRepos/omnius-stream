import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr/dom.dart' show script;
import 'package:jaspr_router/jaspr_router.dart';

class LoginPage extends StatelessComponent {
  const LoginPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(
        className:
            'min-h-screen flex items-center justify-center bg-[#141414] px-4',
        children: [
          Div(
              className:
                  'w-full max-w-md bg-[#1a1a1a] rounded-2xl border border-white/10 p-8',
              children: [
                // Header
                Div(className: 'text-center mb-8', children: [
                  Div(className: 'flex justify-center mb-4', children: [
                    Span(
                        className: 'text-4xl font-bold text-primary-500',
                        child: Text('O')),
                  ]),
                  H1(className: 'text-2xl font-bold text-white mb-2',
                      child: Text('Welcome Back')),
                  P(className: 'text-gray-400 text-sm',
                      child: Text('Sign in to your Omnius account')),
                ]),
                // Form
                Form(
                  id: 'login-form',
                  className: 'space-y-5',
                  children: [
                    // Error display
                    Div(
                        id: 'login-error',
                        className:
                            'hidden p-3 bg-red-500/10 border border-red-500/20 rounded-lg text-red-400 text-sm',
                        children: []),
                    // Email
                    Div(children: [
                      Label(
                          className:
                              'block text-sm font-medium text-gray-300 mb-1.5',
                          htmlFor: 'email',
                          child: Text('Email')),
                      Input(
                        id: 'email',
                        name: 'email',
                        type: 'email',
                        className:
                            'w-full px-4 py-2.5 bg-white/5 border border-white/10 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-500 transition-colors',
                        placeholder: 'you@example.com',
                        attributes: {'required': ''},
                      ),
                    ]),
                    // Password
                    Div(children: [
                      Label(
                          className:
                              'block text-sm font-medium text-gray-300 mb-1.5',
                          htmlFor: 'password',
                          child: Text('Password')),
                      Input(
                        id: 'password',
                        name: 'password',
                        type: 'password',
                        className:
                            'w-full px-4 py-2.5 bg-white/5 border border-white/10 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-500 transition-colors',
                        placeholder: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                        attributes: {'required': ''},
                      ),
                    ]),
                    // Submit
                    Button(
                      type: 'submit',
                      className:
                          'w-full py-3 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                      child: Text('Sign In'),
                    ),
                  ],
                ),
                // Register link
                Div(className: 'mt-6 text-center', children: [
                  Span(className: 'text-sm text-gray-400',
                      child: Text("Don't have an account? ")),
                  Link(
                    to: '/auth/register',
                    child: Span(
                        className:
                            'text-sm text-primary-500 hover:text-primary-400 font-medium',
                        child: Text('Sign up')),
                  ),
                ]),
              ]),
          // Inline script for form handling
          script(content: '''
            (function() {
              const params = new URLSearchParams(window.location.search);
              const redirect = params.get('redirect');

              // Pass redirect param to register link
              if (redirect) {
                const regLink = document.querySelector('a[href*="/auth/register"]');
                if (regLink) regLink.href = '/auth/register?redirect=' + encodeURIComponent(redirect);
              }

              document.getElementById('login-form')?.addEventListener('submit', async (e) => {
                e.preventDefault();
                const errorEl = document.getElementById('login-error');
                errorEl.classList.add('hidden');

                const email = document.getElementById('email').value;
                const password = document.getElementById('password').value;

                try {
                  const res = await fetch('/api/auth/login', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({email, password}),
                  });
                  const data = await res.json();
                  if (res.ok) {
                    window.location.href = redirect || '/app';
                  } else {
                    errorEl.textContent = data.error || 'Login failed';
                    errorEl.classList.remove('hidden');
                  }
                } catch (err) {
                  errorEl.textContent = 'Network error. Please try again.';
                  errorEl.classList.remove('hidden');
                }
              });
            })();
          '''),
        ]);
  }
}
