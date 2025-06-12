FROM node:20-alpine@sha256:d3507a213936fe4ef54760a186e113db5188472d9efdf491686bd94580a1c1e8

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