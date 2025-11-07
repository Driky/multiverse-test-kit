# CAI_Llama3_1_8B_v2_1_0

## Overview

This guide provides step-by-step instructions for and utilizing the CAI_Llama3_1_8B_v2_1_0 model.

## Table of Contents

- Scripts and Directory Structure
- Inference

## Scripts and Directory Structure

The project directory is organized as follows:

```
├── Dockerfile
├── README.md
├── inference_script.py
├── docker-compose.yaml
└── requirements.txt
```

## Set the environment

1. First change the directory to the location of this repository `cai_llama3_1_8b_v2_1_0`
2. Build docker with the following command

```
docker compose build cai_llama
```

3. Open a bash command line inside container using the command:

```
docker compose run cai_llama
```

## Inference

### Run the inference script

To run inference using the compressed model, execute the following command inside the container:

```bash
python inference_script.py
```

### Description of Key Files

- inference_script.py : Script for running inference with the compressed model.
- README.md : Project documentation
