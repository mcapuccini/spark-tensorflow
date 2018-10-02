# Spark + Tensorflow in Docker
[![Build Status](https://travis-ci.org/mcapuccini/spark-tensorflow.svg?branch=master)](https://travis-ci.org/mcapuccini/spark-tensorflow)

A Docker container that wraps Apache Spark and Tensorflow. The container is based on [tensorflow/tensorflow](https://hub.docker.com/r/tensorflow/tensorflow/), and it adds [Hadoop](http://hadoop.apache.org/), [Spark](https://spark.apache.org/) and [Zeppelin](https://zeppelin.apache.org/).

## Software versioning
You can find tagged versions for the container [here](https://hub.docker.com/r/mcapuccini/spark-tensorflow/tags/). If there is no version compatible with your system, please help yourself by adding it to the CI matrix [CI matrix](https://github.com/mcapuccini/spark-tensorflow/blob/master/.travis.yml#L11).


## Examples

### Start Zeppelin
```
docker run -d --rm \
  -e ZEPPELIN_PORT=8888 \
  -p 8888:8888 \
  --name zeppelin \
  mcapuccini/spark-tensorflow:spk-2.1.3-tf-1.10.0-py3-zpl-0.7.3-hdp-2.7.6 \
  sh -c '$Z_HOME/bin/zeppelin.sh'
```
