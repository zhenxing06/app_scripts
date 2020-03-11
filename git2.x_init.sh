#!/bin/bash




curl https://setup.ius.io | sh
yum remove -y git | yum -y install git2u
git --version
