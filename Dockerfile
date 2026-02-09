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
RUN dart build cli -t server/main.dart -o /app/.output

# Runtime stage
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates libsqlite3-0 nginx supervisor && rm -rf /var/lib/apt/lists/*
WORKDIR /app

COPY --from=build /app/.output/bundle /app
COPY --from=build /app/build/jaspr /var/www/html

RUN echo 'server { listen 3000; root /var/www/html; index index.html; location /api { proxy_pass http://127.0.0.1:3001; } location / { try_files $uri $uri/ /index.html; } }' > /etc/nginx/sites-available/default
RUN echo '[supervisord]\nnodaemon=true\n[program:nginx]\ncommand=nginx -g "daemon off;"\n[program:api]\ncommand=/app/bin/main\ndirectory=/app\nenvironment=PORT="3001",DATA_DIR="/app/data"' > /etc/supervisor/conf.d/app.conf
RUN mkdir -p /app/data

ENV PORT=3001 DATA_DIR=/app/data
EXPOSE 3000
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
