#!/bin/bash

for profile in `ag "^\[" ~/.aws/credentials | cut -d ':' -f 2 | sed s/^.// | sed s/.$//`
do
  aws iam get-user --profile $profile
done
