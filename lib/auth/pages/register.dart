import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr/dom.dart' show script;
import 'package:jaspr_router/jaspr_router.dart';

class RegisterPage extends StatelessComponent {
  const RegisterPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(
        className:
            'min-h-screen flex items-center justify-center bg-[#141414] px-4 py-12',
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
                      child: Text('Create Account')),
                  P(className: 'text-gray-400 text-sm',
                      child: Text('Get started with Omnius')),
                ]),
                // Form
                Form(
                  id: 'register-form',
                  className: 'space-y-5',
                  children: [
                    // Error display
                    Div(
                        id: 'register-error',
                        className:
                            'hidden p-3 bg-red-500/10 border border-red-500/20 rounded-lg text-red-400 text-sm',
                        children: []),
                    // Name
                    Div(children: [
                      Label(
                          className:
                              'block text-sm font-medium text-gray-300 mb-1.5',
                          htmlFor: 'name',
                          child: Text('Name')),
                      Input(
                        id: 'name',
                        name: 'name',
                        type: 'text',
                        className:
                            'w-full px-4 py-2.5 bg-white/5 border border-white/10 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-500 transition-colors',
                        placeholder: 'Your name',
                        attributes: {'required': ''},
                      ),
                    ]),
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
                        placeholder: 'Min 8 characters',
                        attributes: {'required': '', 'minlength': '8'},
                      ),
                    ]),
                    // Confirm Password
                    Div(children: [
                      Label(
                          className:
                              'block text-sm font-medium text-gray-300 mb-1.5',
                          htmlFor: 'confirm-password',
                          child: Text('Confirm Password')),
                      Input(
                        id: 'confirm-password',
                        name: 'confirm_password',
                        type: 'password',
                        className:
                            'w-full px-4 py-2.5 bg-white/5 border border-white/10 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-500 transition-colors',
                        placeholder: 'Repeat password',
                        attributes: {'required': ''},
                      ),
                    ]),
                    // Submit
                    Button(
                      type: 'submit',
                      className:
                          'w-full py-3 bg-primary-500 text-white font-semibold rounded-lg hover:bg-primary-600 transition-colors',
                      child: Text('Create Account'),
                    ),
                  ],
                ),
                // Login link
                Div(className: 'mt-6 text-center', children: [
                  Span(className: 'text-sm text-gray-400',
                      child: Text('Already have an account? ')),
                  Link(
                    to: '/auth/login',
                    child: Span(
                        className:
                            'text-sm text-primary-500 hover:text-primary-400 font-medium',
                        child: Text('Sign in')),
                  ),
                ]),
              ]),
          // Inline script for form handling
          script(content: '''
            (function() {
              const params = new URLSearchParams(window.location.search);
              const redirect = params.get('redirect');

              // Pass redirect param to login link
              if (redirect) {
                const loginLink = document.querySelector('a[href*="/auth/login"]');
                if (loginLink) loginLink.href = '/auth/login?redirect=' + encodeURIComponent(redirect);
              }

              document.getElementById('register-form')?.addEventListener('submit', async (e) => {
                e.preventDefault();
                const errorEl = document.getElementById('register-error');
                errorEl.classList.add('hidden');

                const name = document.getElementById('name').value;
                const email = document.getElementById('email').value;
                const password = document.getElementById('password').value;
                const confirm_password = document.getElementById('confirm-password').value;

                if (password !== confirm_password) {
                  errorEl.textContent = 'Passwords do not match';
                  errorEl.classList.remove('hidden');
                  return;
                }

                try {
                  const res = await fetch('/api/auth/register', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({name, email, password, confirm_password}),
                  });
                  const data = await res.json();
                  if (res.ok) {
                    window.location.href = redirect || '/app';
                  } else {
                    errorEl.textContent = data.error || 'Registration failed';
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
