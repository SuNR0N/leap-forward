#!/bin/bash
export AWS_ACCESS_KEY_ID=$(awk '$1=="access_key" { print $3 }' ../terraform.tfvars | awk '{ gsub(/"/, "") } 1')
export AWS_SECRET_ACCESS_KEY=$(awk '$1=="secret_key" { print $3 }' ../terraform.tfvars | awk '{ gsub(/"/, "") } 1')
