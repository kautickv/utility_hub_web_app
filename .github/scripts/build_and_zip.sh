#!/bin/bash

# Change to back_end directory
cd ../back_end
# Install python requirements
python -m pip install -r requirements.txt -t ./python

# Zip the python directory
zip -r ../Infra/layer.zip python/

# Remove the python directory
rm -r python

# Copy 'common' folder to all other folders in the backend directory
for dir in ./*/
do
  echo "$dir"
  if [ "$dir" != "./common/" ]; then
    cp -r ./common/ "$dir"
  fi
done

# List the contents of the parent directory
ls ..
