
# Running AWS IoT Greengrass Core V2 on WAGO Quad-Core ARM Platform Docker Container  
  
## Prerequisites  
* WAGO Edge Controller or WAGO TP600 with Docker Engine installed 
* The Docker Engine ipk (version 20.10 or later) can be found [here](https://github.com/WAGO/docker-ipk ).
  
## Running AWS IoT Greengrass in a Docker Container  
The following steps show how to build the Docker image from the Dockerfile and configure AWS IoT Greengrass to run in a Docker container.  
   
### Step 1. Build the AWS IoT Greengrass Docker Image on the WAGO Edge Controller or TP600     
**1.1** Download and decompress the `wago_aws_greengrass_docker` package.  It is advised that you configure the Docker engine to mount to the SD card.  In a terminal run:
```  
cd /media/docker 
wget https://github.com/jessejamescox/wago_aws_greengrass_docker/archive/refs/heads/main.zip && unzip wago_aws_greengrass_docker-main.zip && rm wago_aws_greengrass_docker-main.zip
```  
  
**1.2** Next, build the Docker image: 
```  
cd /media/docker/wago_aws_greengrass_docker-main
docker build -t wago/aws_greengrass_core . 
```
### Step 2. Running the AWS Greengrass Core container
**2.0** Run the Container with the access to the Docker engine 
Deploy other containers on the host device by mounting the Docker .sock and binaries.  Create YOUR ACCESS KEY ID and YOUR ACCESS KEY in AWS IAM, for the GGC_USER and GGC_GROUP you may nee dto use "root":
```  
docker run -it --network=host \
--restart=unless-stopped \
--env AWS_ACCESS_KEY_ID=<YOUR ACCESS KEY ID> \
--env AWS_SECRET_ACCESS_KEY=<YOUR ACCESS KEY>\
--env AWS_REGION=<YOUR AWS REGION> \
--env THING_NAME=<YOUR GREENGRASS CORE NAME> \
--env THING_GROUP_NAME=<YOUR GREENGRASS CORE GROUP NAME> \
--env GGC_USER=<GREENGRASS CORE USER> \
--env GGC_GROUP=<GREENGRASS CORE GROUP> \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/bin/docker:/usr/bin/docker \
wago/aws_greengrass_core
```
### This is currently beta
Please provide feedback on this as you come accross it. If you wish to contribute please contact me directly.
