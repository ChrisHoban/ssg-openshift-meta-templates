FROM nginx:latest
VOLUME /var/www/html
COPY nginx.conf /etc/nginx/nginx.conf
RUN chown -R 1001:0 /var/cache/nginx && \
    chmod -R a+rwx /var/cache/nginx && \
    chmod -R ug+rwx /var/cache/nginx && \
    chmod -R 0770 /var/www/html

#Security Enhancements
