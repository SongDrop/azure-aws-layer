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