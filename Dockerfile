FROM ubuntu:16.04

# Forked from https://github.com/Spoon4/docker-obs
MAINTAINER William Le <w.le@acaprojects.com>

RUN ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime

# Add obs studio repository and install 
# ffmpeg and obs-studio packages
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y \
              software-properties-common \
              python-software-properties \
    && add-apt-repository \
              ppa:obsproject/obs-studio \
    && apt-get update -y \
    && apt-get install -y \
              ffmpeg \
              obs-studio \ 
              libqt5websockets5 \
    && apt-get install -f \
    && apt-get clean -y

# Install websocket control plugin
RUN wget https://github.com/Palakis/obs-websocket/releases/download/4.3.2/obs-websocket_4.3.2-1_amd64.deb \
    && dpkg -i obs-websocket_4.3.2-1_amd64.deb \\
    && rm obs-websocket_4.3.2-1_amd64.deb

# create user and map on host user
# add new user to sudoers
# TODO: uid / gid could be set with env var
RUN export uid=1000 gid=1000 \
    && mkdir -p /home/obs \
    && echo "obs:x:${uid}:${gid}:OpenBroadcastSoftware,,,:/home/obs:/bin/bash" >> /etc/passwd \
    && echo "obs:x:${uid}:" >> /etc/group \
    && echo "obs ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && chmod 0440 /etc/sudoers \
    && chown ${uid}:${gid} -R /home/obs

USER obs

ENV HOME /home/obs

CMD ["obs"]
