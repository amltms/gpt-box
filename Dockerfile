# Dockerfile

# Build stage
FROM --platform=linux/arm64 node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build

# Production stage
FROM --platform=linux/arm64 node:20-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000

CMD ["npm", "start"]
