FROM r-base:latest

RUN apt-get update && apt-get install -y wget libssl-dev \
	    curl git libcurl4-openssl-dev \
	    libxml2 libxml2-dev libgmp10 \
	    libdbd-mysql libmysqlclient-dev \
	    default-jre

WORKDIR /home/ec2-user
