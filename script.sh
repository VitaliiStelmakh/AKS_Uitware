#!/bin/bash

while true; do
    curl -ksS https://test.loc/api/v1/foods
    sleep 0.001  # Adjust the sleep duration as needed
done
