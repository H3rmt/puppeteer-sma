FROM node:22-alpine@sha256:5539840ce9d013fa13e3b9814c9353024be7ac75aca5db6d039504a56c04ea59

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