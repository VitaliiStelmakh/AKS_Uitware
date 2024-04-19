#!/bin/bash

while true; do
    curl -ksS https://bestrong.eastus.cloudapp.azure.com/api/v1/foods
    sleep 1  # Adjust the sleep duration as needed
done
