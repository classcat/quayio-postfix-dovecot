FROM ubuntu:trusty
MAINTAINER ClassCat Co.,Ltd. <support@classcat.com>

########################################################################
# ClassCat/Ubuntu-Supervisord2 Dockerfile
#   Maintained by ClassCat Co.,Ltd ( http://www.classcat.com/ )
########################################################################

#--- HISTORY -----------------------------------------------------------
# 06-may-15 : fixed.
#-----------------------------------------------------------------------

RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y language-pack-en language-pack-en-base \
  && apt-get install -y language-pack-ja language-pack-ja-base

RUN update-locale LANG="en_US.UTF-8"

RUN apt-get install -y openssh-server supervisor rsyslog mysql-client && apt-get clean

RUN mkdir -p /var/run/sshd

RUN sed -ri "s/^PermitRootLogin\s+.*/PermitRootLogin yes/" /etc/ssh/sshd_config
# RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

ADD assets/supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 22

CMD echo "root:${ROOT_PASSWORD}" | chpasswd; /usr/sbin/sshd -D
