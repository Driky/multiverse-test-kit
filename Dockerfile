FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04

ENV PYTHONPATH="/home/multiverse"

RUN apt-get update && apt-get install -y --no-install-recommends \
  python3-pip \
  python3-dev \
  build-essential \
  gcc \
  g++ \
  && ln -s /usr/bin/python3.10 /usr/bin/python \
  && python -m pip install --upgrade pip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

  
# Add user and copy project files
RUN useradd -m multiverse
COPY . /home/multiverse
RUN chown -R multiverse:multiverse /home/multiverse


# copy the script to the working directory and set permissions
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


# Command to run the script to source the environment variables
ENTRYPOINT ["/entrypoint.sh"]


# Set the user to multiverse
USER multiverse


# Set the working directory
WORKDIR /home/multiverse


# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt


# Command to run the Python script
CMD ["python3", "/home/multiverse/inference_script.py"]
