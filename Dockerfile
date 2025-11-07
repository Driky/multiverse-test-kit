FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04

ENV PYTHONPATH="/opt/project"

RUN apt-get update && apt-get install -y --no-install-recommends \
  python3-pip \
  python3-dev \
  build-essential \
  gcc \
  g++ \
  && ln -s /usr/bin/python3.10 /usr/bin/python \
  && python -m pip install --upgrade pip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/project

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . /opt/project
