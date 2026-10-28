FROM node:20-bookworm

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    make \
    g++ \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY package*.json ./

# Install production dependencies (sqlite3 uses prebuilt binaries when available)
RUN npm install --omit=dev

COPY . .

RUN mkdir -p /app/database

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD curl -f http://localhost:3000/api/dashboard || exit 1

CMD ["node", "server.js"]