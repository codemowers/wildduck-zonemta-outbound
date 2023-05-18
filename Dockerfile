FROM node:lts-alpine as builder
WORKDIR /app
COPY package.json /app
RUN npm install --production

FROM node:lts-alpine as app
ENV NODE_ENV production
RUN apk add --no-cache tini
WORKDIR /app
COPY --from=builder /app /app
ENTRYPOINT ["/sbin/tini", "--", "node", "index.js"]
CMD ["--config=config/zonemta.toml"]
