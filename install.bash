#!/bin/bash

# Clone the repository https://github.com/dunglas/symfony-docker.git in the current directory
git clone --depth 1 https://github.com/dunglas/symfony-docker.git tmp_clone
rm -rf tmp_clone/.git
mv tmp_clone/* .
rm -rf tmp_clone

# Download files from the repository
wget https://raw.githubusercontent.com/samuelferri/symfony-docker-init/refs/heads/main/Makefile -O Makefile
wget https://raw.githubusercontent.com/samuelferri/symfony-docker-init/refs/heads/main/phpstan.neon -O phpstan.neon

# Build and run the containers
make build
make up
