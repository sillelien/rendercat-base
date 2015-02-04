FROM ubuntu:14.04
MAINTAINER Neil Ellis hello@neilellis.me

# Set working directory.
ENV HOME /root
WORKDIR /root

# Env
ENV SLIMERJS_VERSION_M 0.9
ENV SLIMERJS_VERSION_F 0.9.4
# ENV PHANTOM_VERSION 1.9.8

# Update OS.
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-updates multiverse" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-security multiverse" >> /etc/apt/sources.list
RUN apt-get update

# Required directories
RUN mkdir -p /usr/local
RUN mkdir /data
RUN mkdir /app

#Nasty Downloads
RUN mkdir ~/fonts/
RUN apt-get install -y curl
RUN mkdir -p /usr/share/fonts
RUN curl -L "http://dl.bintray.com/neilellis/rendercat/google-fonts.tgz" | tar -C /usr/share/fonts -zxvf  -
RUN curl -L "http://dl.bintray.com/neilellis/rendercat/fonts.tgz" | tar -C /usr/share/fonts -zxvf  -

# RUN curl -L "http://dl.bintray.com/neilellis/rendercat/phantomjs-${PHANTOM_VERSION}-linux-x86_64.tar.bz2" > /tmp/phantomjs-${PHANTOM_VERSION}-linux-x86_64.tar.bz2

#NodeJS
RUN apt-get install -y make gcc g++ wget python software-properties-common
RUN \
  cd /tmp && \
  wget http://nodejs.org/dist/node-latest.tar.gz && \
  tar xvzf node-latest.tar.gz && \
  rm -f node-latest.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc


# Install basic packages.
RUN apt-get install -y  python-urllib3  perl-base perl libc6  dbus libdbus-glib-1-2  bzip2 git htop unzip vim git-core xvfb timelimit psmisc graphicsmagick openssh-server fail2ban

# Download and Install Nginx
RUN apt-get install -y nginx

#Fonts
RUN yes |  apt-get install -y msttcorefonts
RUN  apt-get install -y freetype*
RUN  apt-get install -y fonts-cantarell lmodern ttf-aenigma ttf-georgewilliams ttf-bitstream-vera ttf-sjfonts ttf-tuffy tv-fonts ubuntustudio-font-meta
#ADD bin/install-google-fonts.sh ./
#RUN chmod 755 install-google-fonts.sh
#RUN ./install-google-fonts.sh
RUN fc-cache -fv

#GraphicsMagick
RUN  apt-get install -y graphicsmagick

#CutyCapt
RUN  apt-get install -y cutycapt

#Git Related
RUN curl https://raw.githubusercontent.com/progrium/gitreceive/master/gitreceive > /usr/local/bin/gitreceive
RUN chmod 755 /usr/local/bin/gitreceive
RUN /usr/local/bin/gitreceive init

# PhantomJS
RUN apt-get install -y libfreetype6 libfontconfig1
RUN apt-get install -y phantomjs
# RUN tar -xjvf /tmp/phantomjs-${PHANTOM_VERSION}-linux-x86_64.tar.bz2
# RUN mv phantomjs-${PHANTOM_VERSION}-linux-x86_64 /usr/local/phantomjs-${PHANTOM_VERSION}-linux-x86_64
# #ADD http://rendercatdeps.s3-website-us-east-1.amazonaws.com/phantomjs-1-9-webfonts /usr/local/phantomjs-${PHANTOM_VERSION}-linux-x86_64/bin/phantomjs
# RUN ln -s /usr/local/phantomjs-${PHANTOM_VERSION}-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs
# RUN chmod 755 /usr/local/phantomjs-${PHANTOM_VERSION}-linux-x86_64/bin/phantomjs


# SlimerJS
RUN apt-get install -y dbus libdbus-glib-1-2  bzip2 firefox
RUN wget -O /tmp/slimerjs-$SLIMERJS_VERSION_F-linux-x86_64.tar.bz2 http://download.slimerjs.org/v$SLIMERJS_VERSION_M/$SLIMERJS_VERSION_F/slimerjs-$SLIMERJS_VERSION_F-linux-x86_64.tar.bz2
RUN tar -xjf /tmp/slimerjs-${SLIMERJS_VERSION_F}-linux-x86_64.tar.bz2 -C /tmp
RUN rm -f /tmp/slimerjs-${SLIMERJS_VERSION_F}-linux-x86_64.tar.bz2
RUN mv /tmp/slimerjs-${SLIMERJS_VERSION_F}/ /usr/local/slimerjs
RUN ln -s /usr/local/slimerjs/slimerjs /usr/local/bin/slimerjs

#Supervisord
RUN apt-get install -y supervisor 



