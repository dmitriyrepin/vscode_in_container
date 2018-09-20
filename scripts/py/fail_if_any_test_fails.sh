#!/usr/bin/env bash

if [[ ! -z $(cat ./_coverage/sumary.txt | grep "FAILURES") ]]; then
    # Fail if any of the tests failed
    exit 1
fi