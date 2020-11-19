#!/bin/bash
# **********************************************************
# * Author        : fml
# * Email         : renzhenxing@xianlife.com
# * Create time   : 2020-11-19 16:59
# * Filename      : java.sh
# * Description   : xxxxxxxxxxxxxxxxxxxxxxxxxxx
# **********************************************************



export JAVA_HOME=/data/soft/jdk1.8.0_65
export JRE_HOME=/data/soft/jdk1.8.0_65/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
