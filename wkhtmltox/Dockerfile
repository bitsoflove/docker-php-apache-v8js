FROM doctorlove/docker-php-apache-v8js:7.3

RUN apt-get update -y --fix-missing && \
    apt-get install -y --no-install-recommends \
        libssl-dev \
        libxrender-dev \
        mariadb-client \
        xfonts-75dpi \
        xfonts-base \
        xfonts-utils \
    && cd /tmp \
    && wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb \
    && dpkg -i wkhtmltox_0.12.5-1.buster_amd64.deb \
    && rm -rf /tmp/* \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/phantomjs && \
    curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    | tar -xj --strip-components=1 -C /tmp/phantomjs \
    && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin \
    && rm -rf /tmp/*
