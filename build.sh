#!/usr/bin/env bash

set -e

echo "Building all packages in './src'"
for pkg in './src/*/package.json'; do
  echo "> Building '$(dirname $pkg)'..."
  npm --silent --prefix $(dirname $pkg) install 
done
echo

echo "Initializing Terraform"
terraform -chdir=terraform init
