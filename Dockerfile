FROM amazonlinux:latest

RUN yum install procps tar make gcc python3 python3-devel python3-pip python3-setuptools python3-virtualenv bzip2 fontconfig openssh-clients git -y
RUN curl https://www.sqlite.org/2019/sqlite-autoconf-3290000.tar.gz > sqlite.tar.gz
RUN tar zxvf sqlite.tar.gz && cd sqlite-autoconf-3290000 && ./configure && make && make install

RUN yum clean all && rm -rf /var/cache/yum
RUN ls /usr/local/bin

RUN pip3 install awscli --no-cache-dir

RUN cd /opt \
    && cd /usr/local/bin \
    && ln -s /usr/bin/pydoc3 pydoc \
    && ln -s /usr/bin/python3 python \
    && ln -s /usr/bin/python3-config python-config \
    && ln -s /usr/bin/pip3 pip \
    && ln -s /usr/bin/virtualenv-3.6 virtualenv \
    && set -x \
    && yum -y install libxml2-devel libcurl-devel which \
    && mkdir ~/.gnupg \
    && /bin/bash -l -c "echo disable-ipv6 > ~/.gnupg/dirmngr.conf" \
    && curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
    && curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - \
    && curl -sSL https://get.rvm.io | bash -s stable --ruby \
    && /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install 2.6.3 && rvm --default use 2.6.3" \
    && /bin/bash -l -c "echo 'source /etc/profile.d/rvm.sh' >> ~/.bashrc" \
    && /bin/bash -l -c "gem install bundler:2.1.4" \
    && mkdir ~/.ssh \
    && chmod 700 ~/.ssh
    # Install docker-compose
    # https://docs.docker.com/compose/install/
    # && DOCKER_COMPOSE_URL=https://github.com$(curl -L https://github.com/docker/compose/releases/latest | grep -Eo 'href="[^"]+docker-compose-Linux-x86_64' | sed 's/^href="//' | head -1) \
    # && curl -Lo /usr/local/bin/docker-compose $DOCKER_COMPOSE_URL \
    # && chmod a+rx /usr/local/bin/docker-compose \
    # Basic check it works
    # && docker-compose version \
    # && rm -rf /tmp/* /var/tmp/*

# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
# RUN source ~/.nvm/nvm.sh && nvm install node

# VOLUME /var/lib/docker
# COPY dockerd-entrypoint.sh /usr/local/bin/
# ENV PATH="/usr/local/bin:$PATH"
# ENV LD_LIBRARY_PATH="/usr/local/lib"
# ENV LANG="en_US.utf8"
# CMD ["python3"]
# ENTRYPOINT ["dockerd-entrypoint.sh"]
