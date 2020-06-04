FROM webdevops/php-apache:7.3
ENV V8_VERSION=7.4.288.21

# Install v8js (see https://github.com/phpv8/v8js/blob/php7/README.Linux.md)
RUN apt-get update -y --fix-missing && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        libglib2.0-dev \
        libtinfo5 \
        libtinfo-dev \
        libxml2 \
        patchelf \
        python \
    && cd /tmp \
    \
    && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git --progress --verbose \
    && export PATH="$PATH:/tmp/depot_tools" \
    \
    && fetch v8 \
    && cd v8 \
    && git checkout $V8_VERSION \
    && gclient sync \
    \
    && tools/dev/v8gen.py -vv x64.release -- is_component_build=true use_custom_libcxx=false; \
    \
    export PATH="$PATH:/tmp/depot_tools" \
    && cd /tmp/v8 \
    && ninja -C out.gn/x64.release/ \
    && mkdir -p /opt/v8/lib && mkdir -p /opt/v8/include \
    && cp out.gn/x64.release/lib*.so out.gn/x64.release/*_blob.bin out.gn/x64.release/icudtl.dat /opt/v8/lib/ \
    && cp -R include/* /opt/v8/include/ \
    && for A in /opt/v8/lib/*.so; do patchelf --set-rpath '$ORIGIN' $A;done; \
    \
    cd /tmp \
    && git clone https://github.com/phpv8/v8js.git \
    && cd v8js \
    && phpize \
    && ./configure --with-v8js=/opt/v8 LDFLAGS="-lstdc++" \
    && make \
    && make test \
    && make install \
    && rm -rf /tmp/* \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-enable v8js
