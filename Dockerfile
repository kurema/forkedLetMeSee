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
      ruby ruby-dev eb-utils libeb16-dev git build-essential ca-certificates \
      ispell ienglish-common iamerican-small && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/*

#Enable cgi. This is cgi in 2020.
#https://senyoltw.hatenablog.jp/entry/2015/10/21/175847
RUN sed -ri 's/#LoadModule cgid_module/LoadModule cgid_module/g; \ 
             s/DirectoryIndex index.html/DirectoryIndex index.rb index.cgi index.html/g; \ 
             s/Options Indexes FollowSymLinks/Options Indexes FollowSymLinks ExecCGI/g; \
             s/#AddHandler cgi-script .cgi/AddHandler cgi-script .pl .rb .cgi/g' /usr/local/apache2/conf/httpd.conf

#Setup
RUN cd /tmp && mkdir src && cd src && \
    git clone https://github.com/kubo/rubyeb19.git && \
    cd rubyeb19/ && \
    ruby extconf.rb && \
    make && make install
RUN apt remove -y git build-essential && apt autoremove -y

#DEBUG
#RUN gem -v && ruby -v
#RUN apt-get install -y --no-install-recommends curl
#RUN curl -Lks 'https://git.io/rg-ssl' | ruby

#Add cert
#https://l-w-i.net/t/aws/ec2_100.txt
#https://bundler.io/v2.0/guides/rubygems_tls_ssl_troubleshooting_guide.html#how-ruby-uses-ca-certificates

RUN gem install bundler && gem update --system
RUN gem install iconv

#Copy docs
COPY edict-devel/letmesee/ /usr/local/apache2/htdocs/
RUN chmod 777 /usr/local/apache2/htdocs/*.rb

#I think document should be included.
COPY README.md /

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
