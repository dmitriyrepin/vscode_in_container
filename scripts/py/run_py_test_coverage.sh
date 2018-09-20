#!/usr/bin/env bash

SCRIPT=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(dirname "$SCRIPT")
BASE_DIR=$(realpath "${SCRIPT_DIR}/../")
COVER_DIR=$(realpath "${BASE_DIR}/_coverage")

# https://coverage.readthedocs.io/en/coverage-4.5.1a/cmd.html
# http://www.dahl-jacobsen.dk/data/2018/07/13/test-python-in-vsts/
export COVERAGE_FILE="${COVER_DIR}/data"
export COVERAGE_SOURCE="${BASE_DIR}/src/code"
echo "Running code coverage on '${COVERAGE_SOURCE}'."
coverage erase
# The following will (1) run unit tests in ${BASE_DIR}/src/tests via pytest,
# (2) generate a JUnit test report, and (3) generate code coverage database file
coverage run --source=${COVERAGE_SOURCE} \
    -m py.test -p no:cacheprovider --junitxml ${COVER_DIR}/pytest-junit-report.xml \
    ${BASE_DIR}/src/tests | tee ${COVER_DIR}/sumary.txt
    
# Display text report
coverage report
# generate Coberture code coverage report summary
coverage xml -o ${COVER_DIR}/coverage_summary.xml
# generate Coberture code coverage report
coverage html -d ${COVER_DIR}/coverage_report_html

# Inline CSS to beautify VSTS code coverage display
# TODO: something does not work - fix it later
# python3 /app/src/utils/vsts_inline_css.py ${COVER_DIR}/coverage_report_html
