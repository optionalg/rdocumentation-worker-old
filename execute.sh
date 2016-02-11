#!/bin/bash

# Start the container that calculates which packages to install
printf "Starting custom-r container and executing list_packages.R\n"
docker run --rm --cpu-period=50000 --cpu-quota=20000 --ulimit nproc=200 -v "$PWD":/home/ec2-user -v \
	"$PWD/libs":/usr/local/lib/R/site-library custom-r \
	R CMD BATCH list_packages.R

printf "Generated package_versions\n"

# Create ./log directory if doesn't exist
mkdir -p logs

# Move the output to the logs directory
mv -f list_packages.Rout ./logs/list_packages.Rout
printf "Writing log file\n"

# Start script that will execute the install.packages for all packages in package_versions.RData
printf "Starting custom-r container and executing update_packages.R\n"
docker run --rm --cpu-period=50000 --cpu-quota=20000 --ulimit nproc=200 -v "$PWD":/home/ec2-user -v \
  "$PWD/libs":/usr/local/lib/R/site-library custom-r \
  R CMD BATCH update_packages.R

# Move the output to the logs directory
mv -f update_packages.Rout ./logs/update_packages.Rout
printf "Writing log file\n"

# Start script that will extract the helpfiles of all packages in package_versions.RData
printf "Starting custom-r container and executing extract_helpfiles.R\n"
docker run --rm --cpu-period=50000 --cpu-quota=20000 --ulimit nproc=200 -v "$PWD":/home/ec2-user -v \
  "$PWD/libs":/usr/local/lib/R/site-library custom-r \
  R CMD BATCH extract_helpfiles.R
