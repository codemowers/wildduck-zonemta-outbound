FROM node:lts-alpine as builder
WORKDIR /app
COPY package.json /app
RUN npm install --production
WORKDIR /app/plugins
RUN ln -s ../node_modules/zonemta-wildduck wildduck

FROM node:lts-alpine as app
ENV NODE_ENV production
RUN apk add --no-cache tini
WORKDIR /app
COPY --from=builder /app /app
COPY index.js /app/
ENTRYPOINT ["/sbin/tini", "--", "node", "index.js"]
CMD ["--config=config/zonemta.toml"]
