#!/usr/bin/env sh

# exit if any step fails
set -e

# echo command lines as they are run
set -x

terraform fmt -check -diff -recursive
terraform -chdir=test init
terraform -chdir=test validate
