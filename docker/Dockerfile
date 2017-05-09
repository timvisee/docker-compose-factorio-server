# Base image
FROM alpine:3.4

# Maintainer
MAINTAINER Tim Visée <timvisee@gmail.com>

# Configure the environment
ENV FACTORIO_SERVER_VERSION 0.15.9

# Upgrade and install required packages
RUN apk update \
 && apk upgrade \
 && apk add sudo bash wget git unzip curl

# Download the Factorio server
RUN curl -L "https://www.factorio.com/get-download/${FACTORIO_SERVER_VERSION}/headless/linux64" -o /tmp/factorio-headless.tar.xz \
 && mkdir -p /opt \
 && tar xf /tmp/factorio-headless.tar.xz -C /opt/ \
 && chmod a+x /opt/factorio/bin/x64/factorio

# Delete cache
RUN rm -rf /var/cache/apk/* \
 && rm -rf /root/.cache \
 && rm -rf /tmp/*

# Expose Factorio's port
EXPOSE 34197

# Run the start script
RUN ls -al /
RUN ls -al /opt/factorio
RUN ls -al /opt/factorio/bin
RUN ls -al /opt/factorio/bin/x64

# Copy the initialization file
COPY init.sh /opt/factorio/init.sh

# Run the init script
CMD /opt/factorio/init.sh
