FROM node:16-alpine as builder

RUN npm install -g hexo-cli 
ADD . /src
WORKDIR /src
RUN npm install
RUN hexo g

FROM nginx:alpine
COPY --from=builder /src/public /usr/share/nginx/html
ADD nginx.conf /etc/nginx/conf.d/blog.conf