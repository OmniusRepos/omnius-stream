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

# Runtime stage
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates libsqlite3-0 && rm -rf /var/lib/apt/lists/*
WORKDIR /app

COPY --from=build /app/build/jaspr/app /app/app
COPY --from=build /app/build/jaspr/web /app/web
RUN mkdir -p /app/data

ENV PORT=8080 DATA_DIR=/app/data
EXPOSE 8080
CMD ["./app"]
