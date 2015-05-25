FROM ubuntu:trusty
MAINTAINER ClassCat Co.,Ltd. <support@classcat.com>

########################################################################
# ClassCat/Postfix-Dovecot Dockerfile
#   Maintained by ClassCat Co.,Ltd ( http://www.classcat.com/ )
########################################################################

#--- HISTORY -----------------------------------------------------------
# 25-may-15 : quay.io
#-----------------------------------------------------------------------

RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y language-pack-en language-pack-en-base \
  && apt-get install -y language-pack-ja language-pack-ja-base \
  && update-locale LANG="en_US.UTF-8" \
  && apt-get install -y openssh-server supervisor rsyslog mysql-client \
  && mkdir -p /var/run/sshd \
  && sed -ri "s/^PermitRootLogin\s+.*/PermitRootLogin yes/" /etc/ssh/sshd_config
# RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

ADD assets/supervisord.conf /etc/supervisor/supervisord.conf

ENV DEBIAN_FRONTEND noninteractive

RUN  bash -c 'debconf-set-selections <<< "postfix postfix/main_mailer_type string Internet site"' \
  && bash -c 'debconf-set-selections <<< "postfix postfix/mailname string mail.example.com"' \
  && apt-get -y install postfix sasl2-bin spamassassin spamc \
    dovecot-core dovecot-pop3d dovecot-imapd \
  && apt-get clean

WORKDIR /opt
ADD assets/cc-init.sh /opt/cc-init.sh

ADD assets/spamassassin /etc/default/spamassassin

ADD assets/local.cf /etc/spamassassin/local.cf

ADD assets/dovecot /etc/init.d/dovecot

EXPOSE 22 25 587 110 143

CMD /opt/cc-init.sh; /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
