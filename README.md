# Datatmart POC

This is a sample application built in Rails 5 that rolls up data from an existing store into aggregate records that can be more easily consumed by BI tools.

The specifics of the data set are not the key patterns of value here. The features that have potential reusability are:
* Dynamic ramping up and down of AWS EC2 instances based on an analysis of the dataset
* Deploying code programmatically using the Jenkins CI API
* Aggregating logs of transient servers in Redis and allowing them to be viewed via a web interface
