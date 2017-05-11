# Base image. Alpine Linux with glibc
FROM frolvlad/alpine-glibc:alpine-3.3_glibc-2.23

# Maintainer
MAINTAINER Tim Visée <timvisee@gmail.com>

# Configure the environment
ENV FACTORIO_SERVER_VERSION 0.15.10

# Create and set the work directory
RUN mkdir -p /opt
WORKDIR /opt

# Upgrade and install required packages
RUN apk update \
 && apk upgrade \
 && apk add bash wget

# Download the Factorio server
RUN wget --content-disposition --no-check-certificate "https://www.factorio.com/get-download/${FACTORIO_SERVER_VERSION}/headless/linux64" \
 && if [ -f "factorio_headless_x64_${FACTORIO_SERVER_VERSION}.tar.gz" ]; then \
        tar xzf "factorio_headless_x64_${FACTORIO_SERVER_VERSION}.tar.gz"; \
    elif [ -f "factorio_headless_x64_${FACTORIO_SERVER_VERSION}.tar.xz" ]; then \
        tar xJf "factorio_headless_x64_${FACTORIO_SERVER_VERSION}.tar.xz"; \
    else \
        echo "No valid Factorio archive found!"; \
        exit 1; \
    fi \
 && rm factorio_*

# Delete unused packages and cache
RUN apk del wget \
 && rm -rf /var/cache/apk/* \
 && rm -rf /root/.cache

# Expose Factorio's port
EXPOSE 34197/udp
EXPOSE 27015/tcp

# Copy the initialization file
COPY init.sh /opt/factorio/init.sh

# Run the init script
CMD /opt/factorio/init.sh
