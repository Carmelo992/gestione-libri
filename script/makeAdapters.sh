#!/bin/bash
mkdir adapters
cd adapters
../../../script/makeAdapter.sh $1 api
../../../script/makeAdapter.sh $1 web