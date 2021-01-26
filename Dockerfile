from ubuntu:20.10
# From https://github.com/user5145/docker-build-scripts/blob/master/wine64.sh
# https://github.com/AndreRH/hangover/blob/master/Dockerfile

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y software-properties-common wget
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key && apt-key add winehq.key && add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ groovy main'
RUN add-apt-repository ppa:cybermax-dexter/sdl2-backport
RUN     apt-get install -y --no-install-recommends \
        unzip \
        wget \
        python \
        ca-certificates \
        python \
        flex bison \
        libfreetype6-dev \
        libglib2.0-dev \
        libltdl-dev \
        libxcb1-dev \
        libx11-dev  \
        librsvg2-bin \
        gcc-mingw-w64-x86-64 gcc-mingw-w64-i686 \
        automake autoconf pkg-config libtool \
        automake1.11 autoconf2.13 autoconf2.64 \
        gtk-doc-tools git gperf groff p7zip-full \
        build-essential \
        wine64-tools \
        wine64-development-tools \
        gettext \
        g++ \
        make \
        gcc \
        gcc-mingw-w64                   g++-mingw-w64 \
        xterm                           flex \
        bison                           libgstreamermm-1.0-dev \
        libudev-dev                     libldap2-dev \
        libosmesa6-dev                  libsane-dev \
        libv4l-dev                      liblcms2-dev \
        libpulse-dev                    libxslt1-dev \
        libjpeg-dev                     libgnutls28-dev \
        libvkd3d-dev                    libvkd3d-dev \
        libsdl2-dev                     libkrb5-dev \
        libgssapi-krb5-2                libmpg123-dev \
        libopenal-dev                   libtiff-dev \
        libvulkan-dev                   oss4-dev \
        libpcap-dev                     libncurses-dev \
        libgphoto2-dev                  libcapi20-dev \
        libcups2-dev                    libgsm1-dev \
        ocl-icd-opencl-dev              libfreetype6-dev \
        libfontconfig1-dev              libxcomposite-dev \
        libgettextpo-dev                spirv-headers;
        
RUN ln -s /usr/bin/widl-stable /usr/bin/widl

RUN mkdir /vkd3d && git clone git://source.winehq.org/git/vkd3d.git/ /vkd3d && cd /vkd3d && ./autogen.sh && ./configure && make -j4 && make install
RUN wget -O faudio.tar.gz https://github.com/FNA-XNA/FAudio/archive/21.01.tar.gz && tar -xf faudio.tar.gz && mv FAudio-21.01 /faudio && mkdir /faudio/build && cd /faudio/build && cmake ../ && make && make install
RUN wget https://dl.winehq.org/wine/source/6.0/wine-6.0.tar.xz && tar -xf wine-6.0.tar.xz && mv wine-6.0 /wine
WORKDIR /wine
RUN ln -s /usr/bin/autoconf /usr/bin/autoconf-2.69 && ln -s /usr/bin/autoheader /usr/bin/autoheader-2.69

ENV NOTESTS 1

RUN ./configure --enable-win64
RUN make -j4


RUN cat config.log
