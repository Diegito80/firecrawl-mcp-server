# --- Stage 1: Builder ---
FROM node:18-alpine as builder
WORKDIR /app

# Install all deps including dev tools (for tsc)
COPY package.json package-lock.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# --- Stage 2: Runtime ---
FROM node:18-alpine
WORKDIR /app

# Copy only what we need
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Only install production dependencies
RUN npm ci --omit=dev

# Start server
CMD ["node", "dist/index.js"]
