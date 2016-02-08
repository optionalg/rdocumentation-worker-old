#!/bin/bash
docker run -v "$PWD":/home/ec2-user -v "$PWD/libs":/usr/local/lib/R/site-library custom-r R CMD BATCH list_packages/list_packages.R

mv list_packages.Rout list_packages/logs/list_packages.Rout
