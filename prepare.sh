#!/bin/bash

pushd sum_data_types
pub get || exit 1
popd

pushd sum_data_types_generator
pub get || exit 1
popd

pushd example
pub get || exit 1
popd
