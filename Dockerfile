FROM ubuntu:14.04
MAINTAINER timo.slack@gmail.com
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get -y install python-pip python-dev git
RUN mkdir /opt/rhodecode
RUN mkdir /var/repo
RUN echo "http://samba.org/~jelmer/dulwich/dulwich-0.8.7.tar.gz" > /tmp/req.txt
RUN pip install -r /tmp/req.txt rhodecode==1.7.2
RUN cd /opt/rhodecode && paster make-config RhodeCode production.ini
RUN echo "y" > /tmp/setup.txt

ADD production.ini /opt/rhodecode/production.ini
RUN cd /opt/rhodecode && paster setup-rhodecode production.ini --user=admin --email=admin@example.org --repos=/var/repo --password=admin1234  < /tmp/setup.txt
RUN rm /tmp/setup.txt /tmp/req.txt
RUN apt-get install -y mercurial
CMD cd /opt/rhodecode && paster serve production.ini
