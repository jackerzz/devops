# FROM ubuntu:focal-20220531
FROM ubuntu:focal-20220531
USER root
#================================================
# Customize sources for apt-get
#================================================
RUN  echo "deb http://archive.ubuntu.com/ubuntu focal main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu focal-updates main universe\n" >> /etc/apt/sources.list \
  && echo "deb http://security.ubuntu.com/ubuntu focal-security main universe\n" >> /etc/apt/sources.list
# No interactive frontend during docker build
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

#========================
# Miscellaneous packages
# Includes minimal runtime used for executing non GUI Java programs
#========================
RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    bzip2 \
    ca-certificates \
    openjdk-11-jre-headless \
    tzdata \
    sudo \
    unzip \
    wget \
    jq \
    curl \
    supervisor \
    gnupg2 \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
  && sed -i 's/securerandom\.source=file:\/dev\/random/securerandom\.source=file:\/dev\/urandom/' ./usr/lib/jvm/java-11-openjdk-amd64/conf/security/java.security

#=====
# python3 pip  setuptools
#=====
COPY python3-distutils_3.8.2-1ubuntu1_all.deb python3-lib2to3_3.8.2-1ubuntu1_all.deb /
COPY setuptools-51.1.1.tar.tar pip-20.3.3.tar.tar /
COPY requirements.txt requirements.txt /

RUN tar -zxvf setuptools-51.1.1.tar.tar && tar -zxvf pip-20.3.3.tar.tar

RUN dpkg -i *.deb
RUN cd setuptools-51.1.1 && python3 setup.py install
RUN cd pip-20.3.3 && python3 setup.py install
RUN pip install -r requirements.txt -i https://pypi.doubanio.com/simple
RUN rm -rf ~/.cache/pip
RUN rm -rf python3-distutils_3.8.2-1ubuntu1_all.deb python3-lib2to3_3.8.2-1ubuntu1_all.deb
RUN rm -rf setuptools-51.1.1 pip-20.3.3 setuptools-51.1.1.tar.tar pip-20.3.3.tar.tar requirements.txt pynput-1.7.6.tar.tar

#===================
# Timezone settings
# Possible alternative: https://github.com/docker/docker/issues/3359#issuecomment-32150214
#===================
ENV TZ "UTC"
RUN echo "${TZ}" > /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

#========================================
# Add normal user and group with passwordless sudo
#========================================
RUN groupadd seluser \
         --gid 1201 \
  && useradd seluser \
         --create-home \
         --gid 1201 \
         --shell /bin/bash \
         --uid 1200 \
  && usermod -a -G sudo seluser \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'seluser:secret' | chpasswd
ENV HOME=/home/seluser

#======================================
# Add Grid check script
#======================================
COPY check-grid.sh entry_point.sh /opt/bin/

#======================================
# Add Supervisor configuration file
#======================================
COPY supervisord.conf /etc

#==========
# Selenium & relaxing permissions for OpenShift and other non-sudo environments
#==========
COPY selenium-server-4.3.0.jar /opt/selenium/
RUN  mkdir -p /opt/selenium /opt/selenium/assets /var/run/supervisor /var/log/supervisor \
  && touch /opt/selenium/config.toml \
  && chmod -R 777 /opt/selenium /opt/selenium/assets /var/run/supervisor /var/log/supervisor /etc/passwd \
  # && wget --no-verbose https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.3.0/selenium-server-4.3.0.jar \
  #   -O /opt/selenium/selenium-server.jar \
  && chgrp -R 0 /opt/selenium ${HOME} /opt/selenium/assets /var/run/supervisor /var/log/supervisor \
  && chmod -R g=u /opt/selenium ${HOME} /opt/selenium/assets /var/run/supervisor /var/log/supervisor

#===================================================
# VNC
#===================================================
RUN apt-get update -qqy \
  && apt-get -qqy install \
  x11vnc \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#===================================================
# Run the following commands as non-privileged user
#===================================================
USER 1200:1201
#RUN pip install pynput -i https://pypi.doubanio.com/simple
# Boolean value, maps "--bind-host"
ENV SE_BIND_HOST false

CMD ["/opt/bin/entry_point.sh"]
