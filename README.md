# Rdocumentation-worker

### How to run
* Install [docker](https://docs.docker.com/engine/installation/)
* Create the custom R container `./create_container.sh`
* Install all packages from CRAN by calling `nohup ./execute.sh &`
* The libaries will be in the `./libs` directory
* Logs will be moved to the `./logs` directory when completed (use `tail -f update_packages.Rout` to see how the installation is progressing)
