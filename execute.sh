#!/bin/bash

# Start the container that calculates which packages to install
docker run --rm -v "$PWD":/home/ec2-user -v \
	"$PWD/libs":/usr/local/lib/R/site-library custom-r \
	R CMD BATCH list_packages/list_packages.R

# Move the output to the logs directory
mv list_packages.Rout list_packages/logs/list_packages.Rout

# Start script that will look over the package_versions.json and execute the install.packages

