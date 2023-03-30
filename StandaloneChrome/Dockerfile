# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.txt INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM selenium/node-chrome:4.3.0-20220726

# USER 1200
USER root
#=====
# python3 pip  setuptools
#=====
RUN apt update && apt install python3-evdev git -y 

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
RUN rm -rf setuptools-51.1.1 pip-20.3.3 setuptools-51.1.1.tar.tar pip-20.3.3.tar.tar requirements.txt
#====================================
# Scripts to run Selenium Standalone
#====================================
COPY start-selenium-standalone.sh /opt/bin/start-selenium-standalone.sh

#==============================
# Supervisor configuration file
#==============================
COPY selenium.conf /etc/supervisor/conf.d/

# Copying configuration script generator
COPY generate_config /opt/bin/generate_config
RUN apt autoclean &&  apt autoremove
# Boolean value, maps "--relax-checks"
ENV SE_RELAX_CHECKS true
COPY output.png /usr/share/backgrouds
EXPOSE 4444


