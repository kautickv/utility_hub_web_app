#!/bin/bash

# Change to back_end directory
cd ../back_end
# Install python requirements
#python -m pip install -r requirements.txt -t ./python

# Zip the python directory
#zip -r ../Infra/layer.zip python/

# Remove the python directory
#rm -r python

# List the contents of the current directory
ls

echo "This is main Branch"
# Copy 'common' folder to all other folders in the backend directory
for dir in ./
do
  if [ "$dir" != "./common/" ]; then
    cp -r ./common/ "$dir"
    echo "$dir"
    cd "$dir"
    ls
    cd ..
  fi
done

# List the contents of the parent directory
ls ..