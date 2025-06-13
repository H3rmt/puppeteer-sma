FROM node:22-alpine@sha256:41e4389f3d988d2ed55392df4db1420ad048ae53324a8e2b7c6d19508288107e

RUN apk add --no-cache \
    chromium \
  && rm -rf /var/cache/apk/* /tmp/*

RUN addgroup pptruser \
    && adduser pptruser -D -G pptruser \
    && chown -R pptruser:pptruser /home/pptruser
USER pptruser

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
RUN corepack pnpm install
COPY index.js ./
ENV XDG_CONFIG_HOME=/tmp/.chromium
ENV XDG_CACHE_HOME=/tmp/.chromium
CMD ["node", "index.js"]