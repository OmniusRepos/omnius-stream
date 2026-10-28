# Omnius Stream

The Omnius website, customer dashboard, and licensing/billing backend. This
repository contains a Dart/Jaspr frontend, a Duxt HTTP API, SQLite storage, and
Polar billing integration; it is not the streaming server or player source.

## License status

A license has **not yet been selected**. Public availability is not a grant of
permission to use, modify, or redistribute this code. The owner must add an
appropriate license before presenting the project as open source.

## Run with Docker

Requirements: Docker with internet access to fetch base images, Dart packages,
and build tools.

1. Copy `.env.sample` to a local `.env` and fill in the values needed for your
   own deployment. Keep it private; never reuse previously exposed credentials.
2. Build and run:

   ```sh
   docker build -t omnius-stream:local .
   docker volume create omnius-stream-data
   docker run --rm --name omnius-stream \
     --env-file .env \
     -p 127.0.0.1:8080:8080 \
     -v omnius-stream-data:/app/data \
     omnius-stream:local
   ```

3. Open `http://localhost:8080` for a local smoke check. Use HTTPS for a deployed
   instance; the admin session cookie is marked `Secure`.

Alternatively, after preparing `.env`, use Docker Compose:

```sh
docker compose up --build
```

Compose supplies `.env` to the container, exposes port 8080, and creates a named
volume for `/app/data`. Its port mapping listens on all host interfaces by
default; bind it to loopback or use a firewall/reverse proxy if appropriate.

The image runs Caddy on port **8080**, routing `/api/*` to the API on 3001 and
other requests to the Jaspr server on 3002. SQLite is stored at
`/app/data/omnius_stream.db`; back up the persistent volume before upgrades.
The image's supervisor configuration fixes the API's `PORT` and `DATA_DIR` to
3001 and `/app/data` respectively.

The application reads **process environment variables**. A `.env` file is not
loaded automatically by the application; the Docker command above supplies it
explicitly. Do not pass secrets as Docker build arguments or bake them into an
image.

## Runtime configuration

| Variable | Purpose |
| --- | --- |
| `POLAR_WEBHOOK_SECRET` | Signing secret for your Polar webhook endpoint. Required to accept billing webhooks. |
| `POLAR_ACCESS_TOKEN` | Polar API access for the admin billing views and order synchronization. |
| `ADMIN_SECRET` | Secret used to authenticate the admin interface/API. |
| `POLAR_PERSONAL_PRODUCT_ID` | Your Polar personal-plan product ID; not a secret. |
| `POLAR_BUSINESS_PRODUCT_ID` | Your Polar business-plan product ID; not a secret. |
| `POLAR_ENTERPRISE_PRODUCT_ID` | Your Polar enterprise-plan product ID; not a secret. |
| `DATA_DIR` | Directory for the SQLite database; defaults to the working directory outside the container. |
| `PORT` | API listen port outside the container; defaults to 3001. |

Configure Polar to send relevant order events to your HTTPS
`/api/polar/webhook` endpoint. Keep the signing secret and product IDs consistent
with the Polar environment you are using. Missing admin/API credentials disable
their corresponding functionality rather than creating a default login.

### Basepod

`basepod.yaml` contains deployment settings and non-secret defaults only.
Configure the three secret variables through the deployment platform's secure
application environment settings before deploying. Use your own server, domain,
volume, and product IDs when adapting the manifest.

Current Basepod source applies manifest environment entries only as defaults
for keys that do not already exist. Verify that your deployed Basepod version
has that behavior and that the required secure variables are present before
redeploying; removing a value from Git is not a credential rotation. Do not add
secrets back to the manifest to fix a deployment.

## Development and verification

The Dart SDK constraint is declared in `pubspec.yaml`. The Dockerfile is the
reference for the complete frontend/API build, including Tailwind generation
and the Duxt UI asset-copy step. For Dart dependency resolution and static
analysis:

```sh
dart pub get
dart analyze
```

Run the deterministic security and model-compatibility checks after resolving
dependencies:

```sh
dart run test/polar_webhook_verifier_test.dart
dart run test/model_timestamp_test.dart
```

These use synthetic fixtures, do not contact Polar, and do not open a database.
They exercise signature verification and timestamp serialization compatibility,
not the complete HTTP, database, or billing integration.

The site currently includes Omnius-specific domains, branding, CORS policy,
product IDs, and billing flows. Review those before running a separate public
instance. Commit dependency updates together with `pubspec.lock` and rerun the
checks. The Docker build still uses floating tool/base-image versions; pin and
validate them before cutting a reproducible release. These instructions do not
imply that a production deployment or end-to-end billing flow has been tested.

## Security

See [SECURITY.md](SECURITY.md) for private reporting, secret-handling guidance,
and the steps required after a credential exposure.
