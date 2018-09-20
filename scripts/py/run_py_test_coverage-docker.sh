#!/usr/bin/env bash

# Create a directory owned by the agent user id (it can be removed without 'sudo'). 
# We will volume mount it into a Docker container
mkdir -p _coverage

# Run code coverage in a container and copy results out into `${PWD}/_coverage`
docker run -t --rm \
-p 8080:8080 \
--user $(id -u) \
-v ${PWD}/_coverage:/app/_coverage/ \
--name my-service-test gcr.io/my-google-project/my-service \
/app/scripts/run_py_test_coverage.sh

# Validate that tests and coverage reports were generated 
if [ ! -f ./_coverage/pytest-junit-report.xml ]; then
    echo "Failed to generate unit test report (JUnit XML):"
    ls -l ./_coverage
    exit -1
else
    echo "Generated coverage report summary (XML): ./_coverage/pytest-junit-report.xml"
fi

if [ ! -f ./_coverage/coverage_summary.xml ]; then
    echo "Failed to generate coverage report summary (XML):"
    ls -l ./_coverage
    exit -1
else
    echo "Generated coverage report summary (XML): ./_coverage/coverage_summary.xml"
fi

if [ ! -f ./_coverage/coverage_report_html/index.html ]; then
    echo "Failed to generate coverage report (HTML dir):"
    ls -l ./_coverage
    exit -1
else
    echo "Generated HTML coverage report ./_coverage/coverage_report_html/"
fi
