from ubuntu:20.10
# From https://github.com/user5145/docker-build-scripts/blob/master/wine64.sh
# https://github.com/AndreRH/hangover/blob/master/Dockerfile

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        unzip wget python

RUN     apt-get install -y --no-install-recommends \
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

RUN apt-get install -y build-essential

RUN apt clean && rm -rf /var/lib/apt/lists/*
RUN mkdir /vkd3d && git clone git://source.winehq.org/git/vkd3d.git/ /vkd3d
WORKDIR /vkd3d
RUN apt update && apt install -y wine64-tools
RUN ./autogen.sh && ./configure && make && make install
RUN mkdir /wine && chmod -R 777 /wine
RUN git clone git://source.winehq.org/git/wine.git /wine

#ENV MAKEFLAGS="-j8"
#ENV LDFLAGS="-fstack-protector-strong -Wl -O2 --sort-common --as-needed -z relro -z now"
#ENV FLAGS="-O2 -pipe -fstack-protector-strong -fno-plt -mmmx -msse -msse2 -mssse3 -msse3 -msse4.1 -msse4.2 -mfpmath=sse -mfma -mf16c -mpclmul -mpopcnt -mlzcnt -mavx -maes -mbmi -mbmi2 -mxsave -mxsaveopt -frecord-gcc-switches -D_FORTIFY_SOURCE=1"
#ENV CXXFLAGS=$FLAGS
#ENV CPPFLAGS=$FLAGS
#ENV CFLAGS=$FLAGS
# RUN chmod -R 777 /wine
WORKDIR /wine
RUN ln -s /usr/bin/autoconf /usr/bin/autoconf-2.69 && ln -s /usr/bin/autoheader /usr/bin/autoheader-2.69

RUN /wine/configure                --with-alsa \
--with-capi                     --with-cms \
--without-coreaudio             --with-cups --with-dbus \
--with-fontconfig               --with-freetype \
--with-gettext                  --without-gettextpo \
--with-gphoto                  \
--with-gnutls                   --with-gsm \
--with-gssapi                   --with-gstreamer \
--without-hal                   --with-jpeg \
--with-krb5                     --with-ldap \
--with-mpg123                   --with-netapi \
--with-openal                   --with-opencl \
--with-opengl                   --with-osmesa \
--with-oss                      --with-pcap \
--with-png                      --with-pthread \
--with-pulse                    --with-sane \
--with-sdl                      --with-tiff \
--with-udev \
--with-vkd3d                    --with-vulkan \
--with-xcomposite               --with-xcursor \
--with-xfixes                   --with-xinerama \
--without-xinput                --with-xinput2 \
--with-xml                      --with-xrandr \
--with-xrender                  --with-xshape \
--with-xshm                     --with-xslt \
--with-xxf86vm                 \
--with-x                        --enable-win64;
RUN make


RUN cat config.log
