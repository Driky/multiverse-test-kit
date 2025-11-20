FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04

ENV PYTHONPATH="/home/multiverse"
ENV PATH="/home/multiverse/.local/bin:$PATH"

# Install Python and build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    python3-dev \
    build-essential \
    gcc \
    g++ \
    && ln -s /usr/bin/python3.10 /usr/bin/python \
    && python -m pip install --upgrade pip

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Add user
RUN useradd -m multiverse

# Copy only requirements first to avoid using space unnecessarily
COPY requirements.txt /home/multiverse/

# Switch to the non-root user
USER multiverse
WORKDIR /home/multiverse

# Install Python dependencies in user's home directory
RUN pip install --no-cache-dir --user -r requirements.txt

# Switch back to root to remove build dependencies (saves space)
USER root
RUN apt-get remove -y build-essential gcc g++ python3-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch back to user
USER multiverse

# Copy the rest of the project
COPY --chown=multiverse:multiverse . /home/multiverse

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["python3", "/home/multiverse/inference_script.py"]
