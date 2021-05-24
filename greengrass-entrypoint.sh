#!/bin/sh

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

set -e

#Disable job control so that all child processes run in the same process group as the parent
set +m

# Path that initial installation files are copied to
INIT_JAR_PATH=/opt/greengrassv2
#Default options
OPTIONS="-Droot="/greengrass/v2" -Dlog.store=FILE -jar /GreengrassCore/lib/Greengrass.jar --aws-region ${AWS_REGION} --thing-name ${THING_NAME} --thing-group-name ${THING_GROUP_NAME} --component-default-user ${GGC_USER}:${GGC_GROUP} --provision true --setup-system-service false --deploy-dev-tools true"

# If we have not already installed Greengrass
if [ ! -d $GGC_ROOT_PATH/alts/current/distro ]; then
	# Install Greengrass via the main installer, but do not start running
	echo "Installing Greengrass for the first time..."
	java ${OPTIONS}
else
	echo "Reusing existing Greengrass installation..."
fi

#Make loader script executable
echo "Making loader script executable..."
chmod +x $GGC_ROOT_PATH/alts/current/distro/bin/loader

echo "Starting Greengrass..."

# Start greengrass kernel via the loader script and register container as a thing
exec $GGC_ROOT_PATH/alts/current/distro/bin/loader