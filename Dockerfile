# Build stage
FROM dart:stable AS build
WORKDIR /app

RUN dart pub global activate jaspr_cli && \
    apt-get update && apt-get install -y curl && \
    ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "arm64" ]; then TW_ARCH="arm64"; else TW_ARCH="x64"; fi && \
    curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-$TW_ARCH && \
    chmod +x tailwindcss-linux-$TW_ARCH && mv tailwindcss-linux-$TW_ARCH /usr/local/bin/tailwindcss

COPY pubspec.* ./
RUN dart pub get
COPY . .

RUN mkdir -p .duxt/packages/duxt_ui && cp -r /root/.pub-cache/hosted/pub.dev/duxt_ui-*/lib/* .duxt/packages/duxt_ui/
RUN tailwindcss --input web/styles.tw.css --output web/styles.css --minify
RUN ~/.pub-cache/bin/jaspr build
RUN dart compile exe server/main.dart -o /app/api-server

# Runtime stage
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates libsqlite3-0 libsqlite3-dev caddy supervisor && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Jaspr SSR server binary + web assets
COPY --from=build /app/build/jaspr/app /app/app
COPY --from=build /app/build/jaspr/web /app/web
# API server binary
COPY --from=build /app/api-server /app/api-server

RUN mkdir -p /app/data

# Caddyfile: route /api to API server, everything else to Jaspr SSR
RUN echo '{\n\tadmin off\n}\n:8080 {\n\thandle /api/* {\n\t\treverse_proxy localhost:3001\n\t}\n\thandle {\n\t\treverse_proxy localhost:3002\n\t}\n}' > /etc/caddy/Caddyfile

# Supervisord: run all three processes
RUN echo '[supervisord]\nnodaemon=true\n\n[program:caddy]\ncommand=caddy run --config /etc/caddy/Caddyfile\nautorestart=true\nstdout_logfile=/dev/stdout\nstdout_logfile_maxbytes=0\nstderr_logfile=/dev/stderr\nstderr_logfile_maxbytes=0\n\n[program:jaspr]\ncommand=/app/app\ndirectory=/app\nenvironment=PORT="3002"\nautorestart=true\nstdout_logfile=/dev/stdout\nstdout_logfile_maxbytes=0\nstderr_logfile=/dev/stderr\nstderr_logfile_maxbytes=0\n\n[program:api]\ncommand=/app/api-server\ndirectory=/app\nenvironment=PORT="3001",DATA_DIR="/app/data"\nautorestart=true\nstdout_logfile=/dev/stdout\nstdout_logfile_maxbytes=0\nstderr_logfile=/dev/stderr\nstderr_logfile_maxbytes=0' > /etc/supervisor/conf.d/app.conf

ENV DATA_DIR=/app/data
EXPOSE 8080
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
