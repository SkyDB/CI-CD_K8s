from jenkins/jenkins:lts-alpine
USER root

# Pipeline
RUN /usr/local/bin/install-plugins-cli workflow-aggregator && \
    /usr/local/bin/install-plugins-cli github && \
    /usr/local/bin/install-plugins-cli ws-cleanup && \
    /usr/local/bin/install-plugins-cli greenballs && \
    /usr/local/bin/install-plugins-cli simple-theme-plugin && \
    /usr/local/bin/install-plugins-cli kubernetes && \
    /usr/local/bin/install-plugins-cli docker-workflow && \
    /usr/local/bin/install-plugins-cli kubernetes-cli && \
    /usr/local/bin/install-plugins-cli github-branch-source

# install Maven, Java, Docker, AWS
RUN apk add --no-cache maven \
    openjdk8 \
    docker \
    gettext

# Kubectl
RUN  wget https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# Need to ensure the gid here matches the gid on the host node. We ASSUME (hah!) this
# will be stable....keep an eye out for unable to connect to docker.sock in the builds
# RUN delgroup ping && delgroup docker && addgroup -g 999 docker && addgroup jenkins docker

# See https://github.com/kubernetes/minikube/issues/956.
# THIS IS FOR MINIKUBE TESTING ONLY - it is not production standard (we're running as root!)
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref
