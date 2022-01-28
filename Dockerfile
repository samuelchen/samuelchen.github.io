FROM node:14-alpine as builder

RUN npm install -g hexo-cli@1.1.0 
ADD . /src
WORKDIR /src
RUN npm install
RUN hexo g

FROM nginx:alpine
COPY --from=builder /src/public /usr/share/nginx/html
# ADD nginx.conf /etc/nginx/conf.d/blog.conf