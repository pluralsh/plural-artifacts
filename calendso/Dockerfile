FROM node:14 as deps

WORKDIR /app
COPY calendso/package.json calendso/yarn.lock ./
COPY calendso/prisma prisma
RUN yarn install --frozen-lockfile

FROM node:14 as builder

WORKDIR /app
ARG BASE_URL
ARG NEXT_PUBLIC_APP_URL=https://dummy.example.com
ENV BASE_URL=${NEXT_PUBLIC_APP_URL} \
    NEXT_PUBLIC_APP_URL=$NEXT_PUBLIC_APP_URL \
    NEXT_PUBLIC_LICENSE_CONSENT=agree \
    DATABASE_URL=postgresql://calendso:calendso@calendso/calendso
    
COPY calendso .
COPY seed.ts prisma/seed.ts
COPY --from=deps /app/node_modules ./node_modules
RUN yarn build && yarn install --ignore-scripts --prefer-offline

FROM node:14 as runner
WORKDIR /app
ENV NODE_ENV production

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/scripts ./scripts
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/next-i18next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/lib ./lib
COPY --from=builder /app/package.json ./package.json

COPY docker-entrypoint.sh docker-entrypoint.sh

RUN chmod +x docker-entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["./docker-entrypoint.sh"]