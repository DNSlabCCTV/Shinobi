#
# Builds a custom docker image for ShinobiCCTV Pro
#
FROM node:8-alpine

LABEL Author="MiGoller, mrproper, pschmitt & moeiscool"

# Set environment variables to default values
# ADMIN_USER : the super user login name
# ADMIN_PASSWORD : the super user login password
# PLUGINKEY_MOTION : motion plugin connection key
# PLUGINKEY_OPENCV : opencv plugin connection key
# PLUGINKEY_OPENALPR : openalpr plugin connection key
ENV ADMIN_USER=admin@shinobi.video \
    ADMIN_PASSWORD=admin \
    CRON_KEY=fd6c7849-904d-47ea-922b-5143358ba0de \
    PLUGINKEY_MOTION=b7502fd9-506c-4dda-9b56-8e699a6bc41c \
    PLUGINKEY_OPENCV=f078bcfe-c39a-4eb5-bd52-9382ca828e8a \
    PLUGINKEY_OPENALPR=dbff574e-9d4a-44c1-b578-3dc0f1944a3c \
    #leave these ENVs alone unless you know what you are doing
    MYSQL_USER=majesticflame \
    MYSQL_PASSWORD=password \
    MYSQL_HOST=localhost \
    MYSQL_DATABASE=ccio \
    MYSQL_ROOT_PASSWORD=blubsblawoot \
    MYSQL_ROOT_USER=root


# Create the custom configuration dir
RUN mkdir -p /config

# Create the working dir
RUN mkdir -p /opt/shinobi


# Install package dependencies
RUN apk update && \
apk upgrade && \
apk --no-cache add   freetype-dev \
  gnutls-dev \
  lame-dev \
  libass-dev \
  libogg-dev \
  libtheora-dev \
  libvorbis-dev \
  libvpx-dev \
  libwebp-dev \
  libssh2 \
  opus-dev \
  rtmpdump-dev \
  x264-dev \
  x265-dev \
  yasm-dev && \
apk add --no-cache   --virtual \
  .build-dependencies \
  build-base \
  bzip2 \
  coreutils \
  gnutls \
  nasm \
  tar \
  x264


# plus object Detection
#-----------------------------------------------------------------------------------------------


ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++
ENV OPENCV_VERSION=3.4.0

RUN echo -e '@edgunity http://nl.alpinelinux.org/alpine/edge/community\n\
@edge http://nl.alpinelinux.org/alpine/edge/main\n\
@testing http://nl.alpinelinux.org/alpine/edge/testing\n\
@community http://dl-cdn.alpinelinux.org/alpine/edge/community'\
  >> /etc/apk/repositories

RUN apk add --update --no-cache \
      build-base \
      openblas-dev \
      unzip \
      wget \
      cmake \
      # A C language family front-end for LLVM (development files)
      clang-dev \
      qt5-qtbase-dev \
      linux-headers && \ 

    mkdir -p /opt && \
    cd /opt && \
    wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && \
    rm -rf ${OPENCV_VERSION}.zip && \

    # download and extract opencv-contrib
    wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && \
    rm -rf ${OPENCV_VERSION}.zip && \

    mkdir -p /opt/opencv-${OPENCV_VERSION}/build && \
    cd /opt/opencv-${OPENCV_VERSION}/build && \
    cmake \
      -D CMAKE_FIND_LIBRARY_SUFFIXES=.a \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D BUILD_SHARED_LIBS=OFF \
      -D WITH_FFMPEG=OFF \
      -D WITH_1394=OFF \
      -D WITH_IPP=OFF \
      -D WITH_QT=ON \
      -D WITH_OPENEXR=OFF \
      -D WITH_TBB=YES \
      -D WITH_WEBP=OFF \
      -D WITH_TIFF=OFF \
      -D WITH_PNG=OFF \
      -D WITH_JASPER=OFF \
      -D BUILD_TBB=ON \
      -D BUILD_JPEG=ON \
      -D BUILD_IPP_IW=OFF \
      -D BUILD_ZLIB=ON \
      -D BUILD_FAT_JAVA_LIB=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_ANDROID_EXAMPLES=OFF \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D BUILD_DOCS=OFF \
      -D BUILD_opencv_python2=OFF \
      -D BUILD_opencv_python3=OFF \
      -D BUILD_opencv_apps=OFF \
      -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV_VERSION}/modules \
      .. && \
      make -j "$(getconf _NPROCESSORS_ONLN)" && \
      make install && \
      rm -rf /opt/opencv-${OPENCV_VERSION} && \
      rm -rf /opt/opencv_contrib-${OPENCV_VERSION}



#-----------------------------------------------------------------------------------------------



#Plugin Motion Detection
#------------------------------------------------------------------------
RUN apk update && \
apk upgrade && \
apk --no-cache add jpeg-dev \
  pango-dev \
  giflib-dev \
  alpine-sdk \
  gcc \
  g++

RUN apk update && \
apk upgrade && \
apk --no-cache add xvidcore-dev \
  x264-dev

RUN apk update && \
apk upgrade && \
apk --no-cache add openblas \
  gfortran

RUN apk update && \
apk upgrade && \
apk --no-cache add alpine-sdk \
  cmake \
  unzip \
  ffmpeg \
  qt5-qtbase-dev \
  python-dev \
  python3-dev \
  py-numpy \
  py3-numpy \
  gtk+3.0-dev \
  libdc1394 \
  libdc1394-dev \
  jpeg-dev \
  tiff-dev \
  tesseract-ocr-dev
RUN apk update && \
apk upgrade && \
apk --no-cache add ffmpeg-dev \
  libpng-dev \
  v4l-utils-dev \
  lame-dev \
  ffmpeg-libs \
  libtheora-dev \
  libvorbis-dev \
  v4l-utils \
  leptonica-dev

RUN apk update && \
apk upgrade && \
apk --no-cache add curl \
  cmake \
  linux-headers


#-------------------------------------------------------------














RUN apk add --update --no-cache python make ffmpeg pkgconfig git mariadb mariadb-client wget tar xz openrc
RUN sed -ie "s/^bind-address\s*=\s*127\.0\.0\.1$/#bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# Install ffmpeg static build version from cdn.shinobi.video
RUN wget https://cdn.shinobi.video/installers/ffmpeg-release-64bit-static.tar.xz

RUN tar xpvf ./ffmpeg-release-64bit-static.tar.xz -C ./ \
    && cp -f ./ffmpeg-3.3.4-64bit-static/ff* /usr/bin/ \
    && chmod +x /usr/bin/ff*

RUN rm -f ffmpeg-release-64bit-static.tar.xz \
    && rm -rf ./ffmpeg-3.3.4-64bit-static

WORKDIR /opt/shinobi

# Clone the Shinobi CCTV PRO repo
RUN git clone https://gitlab.com/Shinobi-Systems/Shinobi.git /opt/shinobi

# Install NodeJS dependencies
RUN npm i npm@latest -g

RUN npm install pm2 -g

RUN npm install canvas@1.6 moment --unsafe-perm

RUN npm install

RUN npm audit fix


RUN cp /opt/shinobi/plugins/motion/conf.sample.json /opt/shinobi/plugins/motion/conf.json


# Copy code
COPY docker-entrypoint.sh .
COPY pm2Shinobi.yml .
RUN mkdir ./plugins/opencv/cascades
COPY ./cascades ./plugins/opencv/cascades
RUN chmod -f +x ./*.sh

RUN chmod -f +x ./plugins/opencv/INSTALL.sh

RUN cp /opt/shinobi/plugins/opencv/conf.sample.json /opt/shinobi/plugins/opencv/conf.json

# Copy default configuration files
COPY ./config/conf.sample.json /opt/shinobi/conf.sample.json
COPY ./config/super.sample.json /opt/shinobi/super.sample.json

VOLUME ["/opt/shinobi/videos"]
VOLUME ["/config"]
VOLUME ["/var/lib/mysql"]

EXPOSE 8080

ENTRYPOINT ["/opt/shinobi/docker-entrypoint.sh"]

CMD ["pm2-docker", "pm2Shinobi.yml"]

                                                                               
