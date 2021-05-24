# MIT License

# Copyright (c) 2021 Jesse Cox

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM ubuntu

# Author
LABEL maintainer="Jesse Cox - WAGO USA"

# Replace the args to lock to a specific version
ARG GREENGRASS_RELEASE_VERSION=2.1.0
ARG GREENGRASS_ZIP_FILE=greengrass-${GREENGRASS_RELEASE_VERSION}.zip
ARG GREENGRASS_RELEASE_URI=https://d2s8p88vqu9w66.cloudfront.net/releases/${GREENGRASS_ZIP_FILE}
ARG GREENGRASS_ZIP_SHA256=${GREENGRASS_ZIP_FILE}.sha256

# Set up Greengrass v2 execution parameters
# TINI_KILL_PROCESS_GROUP allows forwarding SIGTERM to all PIDs in the PID group so Greengrass can exit gracefully
#ENV TINI_KILL_PROCESS_GROUP=1 \ 
ENV GGC_ROOT_PATH=/greengrass/v2
#    PROVISION=false \
#    AWS_REGION=us-west-2 \
#    THING_NAME=default_thing_name \
#    THING_GROUP_NAME=default_thing_group_name \
#    TES_ROLE_NAME=default_tes_role_name \
#    TES_ROLE_ALIAS_NAME=default_tes_role_alias_name \
#    COMPONENT_DEFAULT_USER=default_component_user \
#    DEPLOY_DEV_TOOLS=false \
#    INIT_CONFIG=default_init_config
RUN env

# Entrypoint script to install and run Greengrass
COPY "greengrass-entrypoint.sh" /
COPY "${GREENGRASS_ZIP_SHA256}" /

# Install Greengrass v2 dependencies
RUN apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev \
    libffi-dev wget curl python3-pip git software-properties-common default-jdk unzip -y && \ 
    wget $GREENGRASS_RELEASE_URI && sha256sum -c ${GREENGRASS_ZIP_SHA256} && \
    chmod +x /greengrass-entrypoint.sh && \
    mkdir -p /opt/greengrassv2 $GGC_ROOT_PATH && unzip $GREENGRASS_ZIP_FILE -d /opt/greengrassv2 && rm $GREENGRASS_ZIP_FILE && rm $GREENGRASS_ZIP_SHA256

ENTRYPOINT ["/greengrass-entrypoint.sh"]