# azure-aws-layer
python 3.10 azure AWS Layer 

layer.zip contains the packed azure resources in python 3.10 so you just upload to your AWS Lambda function, and add as a layer, and ready to use.


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AWS Lambda Python Layer Build Using Docker

In this guide, we encountered an issue where the urllib3 package requires OpenSSL 1.1.1+, but the 'ssl' module in our current AWS Lambda environment is compiled with 'OpenSSL 1.0.2k-fips 26 Jan 2017'.

To resolve this, we need migrate from Python3.8 to use Python3.10 on AWS Lambda which includes an updated version of OpenSSL.

We also had the limitation of maximum 5 AWS Lambda Layers, where a single Lambda function. 
Our task requires the following packages:
    azure-core
    azure-identity
    azure-mgmt-compute
    azure-mgmt-dns
    azure-mgmt-network
    azure-storage-blob 

To overcome this, we will pack all these into a single custom Python layer using Docker and AWS Lambda's Python 3.10 image.



Here's a Dockerfile to build this layer:

FROM public.ecr.aws/lambda/python:3.10

# Create a new directory for your python packages
RUN mkdir -p /python

# Install the zip utility
RUN yum -y update && yum install -y zip

# Include the necessary python packages
COPY requirements.txt /
RUN pip install --upgrade pip
RUN pip install --target=/python -r /requirements.txt

# After installing the packages, package them into a .zip file
RUN cd / && zip -r /layer.zip python/*

In this Dockerfile:

    We start with the lambda python 3.10 image.
    We create a new directory /python to hold all of our Python package installations.
    Install the 'zip' utility which is required to make a zip for the Lambda Layer.
    Copy our requirements.txt file which has the Python packages we need, into the Docker image.
    Upgrade pip to its latest version and then install all the packages from requirements.txt into the /python directory we created earlier.
    Finally, we create a .zip file containing all the installed packages. This .zip file serves as the deployment package for the Lambda Layer. 

By following this approach, you can build a custom AWS Lambda Layer to contain all the necessary Python packages for your use case, overcoming the AWS Lambda Layer limit by packing multiple packages into a single layer.
