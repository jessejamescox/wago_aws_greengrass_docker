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

FROM debian

# Author
LABEL maintainer="Jesse Cox - WAGO USA"

# Replace the args to lock to a specific version
ARG GREENGRASS_RELEASE_URI=https://d2s8p88vqu9w66.cloudfront.net/releases/greengrass-nucleus-latest.zip

# Set up Greengrass v2 execution parameters
ENV GGC_ROOT_PATH=/greengrass/v2
RUN env

# Entrypoint script to install and run Greengrass
COPY "greengrass-entrypoint.sh" /

# install Greengrass v2 dependencies
RUN apt update && apt upgrade -y && apt install build-essential zlib1g-dev \
    libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget \
    curl python3-pip git software-properties-common default-jdk unzip -y

# download and extract the runtime files    
RUN curl -s ${GREENGRASS_RELEASE_URI} > \
    greengrass-nucleus-latest.zip && unzip greengrass-nucleus-latest.zip -d GreengrassCore &&\
    chmod +x /greengrass-entrypoint.sh

ENTRYPOINT ["/greengrass-entrypoint.sh"]