#!/bin/bash
if [ "$1" = "all" ]; then
  TESTS="test/unit test/motion"
else
  TESTS="test/motion"
fi

BUNDLE_GEMFILE=foo rake $TESTS