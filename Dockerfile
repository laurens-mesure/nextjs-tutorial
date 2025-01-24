FROM node:20-alpine AS base

FROM base AS builder
RUN apk update && apk add --no-cache libc6-compat

WORKDIR /app

COPY . .

ENV NEXT_TELEMETRY_DISABLED 1

RUN corepack enable pnpm
RUN pnpm install
RUN pnpm build

FROM base AS runner

RUN apk --no-cache add curl
RUN npm i -g sharp

WORKDIR /app

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

ENV NEXT_TELEMETRY_DISABLED=1 \
    NEXT_SHARP_PATH=/usr/local/lib/node_modules/sharp \
    NODE_ENV=production \
    HOSTNAME=0.0.0.0 \
    PORT=3001

COPY --from=builder --chown=nextjs:nodejs /app/build ./

USER nextjs

EXPOSE 3001

CMD ["node", "server.js"]
