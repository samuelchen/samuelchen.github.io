FROM node:10-alpine as builder

RUN npm install -g hexo-cli@4.3.0
ADD . /src
WORKDIR /src
RUN npm install
RUN hexo g

FROM nginx:alpine
COPY --from=builder /src/public /usr/share/nginx/html
# ADD nginx.conf /etc/nginx/conf.d/blog.conf