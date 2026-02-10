import 'package:duxt_html/duxt_html.dart';
import 'package:jaspr/jaspr.dart' show StatelessComponent, BuildContext;
import 'package:jaspr/dom.dart' show script;
import 'package:jaspr_router/jaspr_router.dart';

class SuccessPage extends StatelessComponent {
  const SuccessPage({super.key});

  @override
  Component build(BuildContext context) {
    return Div(
        className:
            'min-h-screen flex items-center justify-center bg-[#141414] px-4',
        children: [
          Div(
              className:
                  'w-full max-w-lg bg-[#1a1a1a] rounded-2xl border border-white/10 p-8 text-center',
              children: [
                // Loading state
                Div(id: 'loading-state', children: [
                  Div(
                      className:
                          'inline-flex items-center justify-center w-16 h-16 rounded-full bg-primary-500/10 mb-6',
                      children: [
                        Span(className: 'text-3xl animate-spin',
                            child: Text('\u23f3')),
                      ]),
                  H1(className: 'text-2xl font-bold text-white mb-3',
                      child: Text('Processing Your Purchase...')),
                  P(className: 'text-gray-400 mb-4',
                      child: Text(
                          'We\'re generating your license key. This usually takes a few seconds.')),
                  Div(
                      className:
                          'w-48 h-1 bg-white/10 rounded-full mx-auto overflow-hidden',
                      children: [
                        Div(
                            className:
                                'h-full bg-primary-500 rounded-full animate-pulse',
                            children: []),
                      ]),
                ]),

                // Success state (hidden initially)
                Div(id: 'success-state', className: 'hidden', children: [
                  Div(
                      className:
                          'inline-flex items-center justify-center w-16 h-16 rounded-full bg-green-500/10 mb-6',
                      children: [
                        Span(className: 'text-3xl text-green-500',
                            child: Text('\u2713')),
                      ]),
                  H1(className: 'text-2xl font-bold text-white mb-3',
                      child: Text('Purchase Complete!')),
                  P(className: 'text-gray-400 mb-6',
                      child: Text('Your license key is ready:')),
                  // License key display
                  Div(
                      className:
                          'p-4 bg-white/5 rounded-xl border border-white/10 mb-4',
                      children: [
                        Div(id: 'plan-badge', className: 'mb-2', children: []),
                        Div(
                            className:
                                'flex items-center justify-between gap-3',
                            children: [
                              Code(
                                id: 'license-key',
                                className:
                                    'text-lg font-mono text-primary-500 font-bold',
                                child: Text(''),
                              ),
                              Button(
                                id: 'copy-btn',
                                className:
                                    'px-3 py-1.5 bg-white/10 text-white text-xs rounded-lg hover:bg-white/20 transition-colors',
                                child: Text('Copy'),
                              ),
                            ]),
                      ]),
                  // Run command
                  Div(className: 'mt-6 text-left', children: [
                    P(className: 'text-sm text-gray-400 mb-3',
                        child: Text('Run your server:')),
                    Div(
                        className:
                            'rounded-xl bg-[#0d0d0d] border border-white/10 p-4 overflow-x-auto',
                        children: [
                          Pre(child:
                            Code(
                              id: 'docker-cmd',
                              className:
                                  'text-xs text-gray-300 whitespace-pre',
                              child: Text(''),
                            )),
                        ]),
                  ]),
                  // Links
                  Div(className: 'mt-8 flex justify-center gap-4', children: [
                    Link(
                      to: '/app/setup',
                      child: Span(
                          className:
                              'px-5 py-2.5 bg-primary-500 text-white font-semibold rounded-lg text-sm hover:bg-primary-600 transition-colors',
                          child: Text('Setup Guide')),
                    ),
                    Link(
                      to: '/app',
                      child: Span(
                          className:
                              'px-5 py-2.5 border border-white/20 text-white font-semibold rounded-lg text-sm hover:bg-white/5 transition-colors',
                          child: Text('Dashboard')),
                    ),
                  ]),
                ]),

                // Error state (hidden initially)
                Div(id: 'error-state', className: 'hidden', children: [
                  Div(
                      className:
                          'inline-flex items-center justify-center w-16 h-16 rounded-full bg-red-500/10 mb-6',
                      children: [
                        Span(className: 'text-3xl text-red-500',
                            child: Text('\u2717')),
                      ]),
                  H1(className: 'text-2xl font-bold text-white mb-3',
                      child: Text('Something Went Wrong')),
                  P(className: 'text-gray-400 mb-6',
                      child: Text(
                          'We couldn\'t find your license. Please contact support at hello@omnius.stream')),
                ]),
              ]),
          // Polling script
          script(content: '''
              (function() {
                const params = new URLSearchParams(window.location.search);
                var email = params.get('email');
                const checkoutId = params.get('checkout_id');

                // Try to get email from logged-in user session
                var userEmailPromise = fetch('/api/auth/me')
                  .then(function(r) { return r.json(); })
                  .then(function(data) {
                    if (data.user && data.user.email) {
                      email = data.user.email;
                    }
                  })
                  .catch(function() {});

                userEmailPromise.then(function() {
                  if (!email && !checkoutId) {
                    document.getElementById('loading-state').classList.add('hidden');
                    document.getElementById('error-state').classList.remove('hidden');
                    return;
                  }
                  setTimeout(poll, pollInterval);
                });

                let attempts = 0;
                const maxAttempts = 20;
                const pollInterval = 3000;

                function poll() {
                  attempts++;
                  var lookupParam = '';
                  if (checkoutId) {
                    lookupParam = 'checkout_id=' + encodeURIComponent(checkoutId);
                    if (email) lookupParam += '&email=' + encodeURIComponent(email);
                  } else if (email) {
                    lookupParam = 'email=' + encodeURIComponent(email);
                  }
                  fetch('/api/licenses/lookup?' + lookupParam)
                    .then(r => r.json())
                    .then(data => {
                      if (data.license) {
                        showSuccess(data.license);
                      } else if (attempts < maxAttempts) {
                        setTimeout(poll, pollInterval);
                      } else {
                        showError();
                      }
                    })
                    .catch(() => {
                      if (attempts < maxAttempts) {
                        setTimeout(poll, pollInterval);
                      } else {
                        showError();
                      }
                    });
                }

                function showSuccess(license) {
                  document.getElementById('loading-state').classList.add('hidden');
                  document.getElementById('success-state').classList.remove('hidden');
                  document.getElementById('license-key').textContent = license.license_key;

                  var badge = document.getElementById('plan-badge');
                  badge.innerHTML = '<span class="inline-block px-3 py-1 bg-primary-500/10 text-primary-500 text-xs font-semibold rounded-full">' +
                    license.plan.toUpperCase() + ' \u2022 ' + license.max_deployments + ' deployment(s)</span>';

                  var dockerCmd = document.getElementById('docker-cmd');
                  dockerCmd.textContent = 'LICENSE_KEY=' + license.license_key + ' \\\\\n  ADMIN_PASSWORD=your_secure_password \\\\\n  ./omnius-linux-amd64';

                  document.getElementById('copy-btn').addEventListener('click', function() {
                    navigator.clipboard.writeText(license.license_key);
                    this.textContent = 'Copied!';
                    setTimeout(() => { this.textContent = 'Copy'; }, 2000);
                  });
                }

                function showError() {
                  document.getElementById('loading-state').classList.add('hidden');
                  document.getElementById('error-state').classList.remove('hidden');
                }

              })();
            '''),
        ]);
  }
}
