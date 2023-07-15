FROM node:16 AS build-step
WORKDIR /app
COPY . .

RUN npm install --legacy-peer-deps
ENV NODE_OPTIONS=--max_old_space_size=4096
RUN npm run build
RUN ls -alht build

FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-step /app/build /usr/share/nginx/html
RUN ls -alht /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]