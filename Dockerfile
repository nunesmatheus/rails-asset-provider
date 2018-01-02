FROM phusion/baseimage

RUN apt-get update && apt-get install -y openssh-server git nginx wget ruby-full
# grab this password from docker --build-arg
RUN echo 'root:jdkas21312doium23901m012u03' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Install docker for building images to update deployment
ENV DOCKER_API_VERSION 1.23
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update
RUN apt-get -y install docker-ce

RUN mkdir -p ~/.ssh
RUN mkdir /apps

ADD config-parser.rb /config-parser.rb

WORKDIR /
RUN git init --bare app.git
COPY hooks app.git/hooks
WORKDIR /app.git

# TODO: create script to add local ssh public key to builder authorized_keys with kubectl run
EXPOSE 22
EXPOSE 80


# NGINX setup
COPY nginx-default.conf /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/sites-enabled/default

RUN dpkg-reconfigure openssh-server

CMD ["/sbin/my_init"]


RUN mkdir -p /etc/service/ssh
COPY ssh.sh /etc/service/ssh/run

RUN mkdir -p /etc/service/nginx
COPY nginx.sh /etc/service/nginx/run
