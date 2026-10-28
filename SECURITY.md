# Security

## Reporting a vulnerability

Do not post credentials, customer data, or a working exploit in a public issue.
If this repository's **Security** tab offers **Report a vulnerability**, use
that private reporting flow. Otherwise, contact the repository owner privately
using a contact method they publish on GitHub and ask for a secure reporting
channel. No dedicated security email or response-time commitment is currently
published here.

Include the affected commit/version, impact, and minimal reproduction steps
using synthetic data. Coordinate disclosure with the owner before publishing
sensitive details. No supported-release or security-maintenance schedule has
been established yet.

## Secrets and deployment

- Keep `POLAR_WEBHOOK_SECRET`, `POLAR_ACCESS_TOKEN`, and `ADMIN_SECRET` in a
  deployment secret store or private runtime environment, never in Git,
  `basepod.yaml`, screenshots, logs, build arguments, or container layers.
- `.env.sample` contains empty placeholders only. Keep local `.env` files
  untracked and outside the Docker build context. The application does not
  automatically load them.
- Use HTTPS and verify webhook signatures before processing billing events.
  Keep the server clock accurate for timestamp validation. Do not bypass
  verification to diagnose a signing-secret mismatch.
- Protect and back up the SQLite database: it contains customer, order,
  deployment, and license information. Do not publish database files or live
  production logs as examples or test fixtures.

## If a credential was exposed

Treat it as compromised even if the repository is later made private or its
history is rewritten. The authorized account owner should revoke/rotate the
affected credentials at the issuer, update the secure runtime settings, and
verify that the old credentials no longer work. For a webhook signing secret,
coordinate the provider and receiver change so legitimate billing events are
not lost. Rotate the application admin secret and review relevant access and
billing activity as well.

Removing secrets from the current files is not sufficient: clean affected Git
history and relevant build caches/artifacts, and coordinate with collaborators
so old branches or clones do not reintroduce them. A force-push cannot erase
third-party clones, forks, cached views, or previously downloaded images. Ask
the hosting provider about sensitive-data removal where necessary. Never put
the leaked values into remediation issues, commit messages, or test cases.
