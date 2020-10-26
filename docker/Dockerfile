FROM httpd

MAINTAINER kurema

#You need to install tzdata first to prevent 'Please select the geographic area...' message.
#https://sleepless-se.net/2018/07/31/docker-build-tzdata-ubuntu/
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends tzdata

#Timezone is set to Japan assuming you are in Japan.
ENV TZ=Asia/Tokyo
#Install dependencies.
RUN apt-get install -y --no-install-recommends \
      ruby ruby-dev eb-utils libeb16-dev git && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/*

#Enable cgi. This is cgi in 2020.
#https://senyoltw.hatenablog.jp/entry/2015/10/21/175847
RUN sed -ri 's/#LoadModule cgid_module/LoadModule cgid_module/g; \ 
             s/DirectoryIndex index.html/DirectoryIndex index.rb index.cgi index.html/g; \ 
             s/Options Indexes FollowSymLinks/Options Indexes FollowSymLinks ExecCGI/g; \
             s/#AddHandler cgi-script .cgi/AddHandler cgi-script .pl .cgi/g' /usr/local/apache2/conf/httpd.conf

#I think document should be included.
COPY README.md /

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
