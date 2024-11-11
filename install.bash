#!/bin/bash

# Clone the repository https://github.com/dunglas/symfony-docker.git in the current directory
if [ ! -d public ]; then
  git clone --depth 1 https://github.com/dunglas/symfony-docker.git tmp_clone
  rm -rf tmp_clone/.git
  mv tmp_clone/* .
  rm -rf tmp_clone
fi
