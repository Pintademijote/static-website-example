#Grab the latest alpine image
FROM httpd:2.4

COPY ./web/ /usr/local/apache2/htdocs/

EXPOSE 80
