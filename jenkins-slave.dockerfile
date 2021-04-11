
FROM jenkins/inbound-agent:4.7-1

USER root
WORKDIR /

# kubectl v1.21.0
COPY ./kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl
# helm v3.5.3
COPY ./helm /usr/local/bin/helm
RUN chmod +x /usr/local/bin/helm

RUN sed -i 's#http://deb.debian.org#http://mirrors.aliyun.com#g' /etc/apt/sources.list && apt update -y
RUN apt install -y apt-transport-https ca-certificates curl gnupg lsb-release \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update -y \
    && apt install docker-ce docker-ce-cli containerd.io -y

USER root
