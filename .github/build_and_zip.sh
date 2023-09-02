#!/bin/bash

# Install python requirements
python -m pip install -r requirements.txt -t ./python

# Zip the python directory
zip -r ../Infra/layer.zip python/

# Remove the python directory
rm -r python

# List the contents of the current directory
ls
