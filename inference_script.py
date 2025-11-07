# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project

from pathlib import Path
import os
from vllm import LLM, SamplingParams

# Model path (using the same path as before)

model_path = os.environ.get('KIT_INPUTS_FILE')

# Sample prompts.
prompts = [
    "Hello, my name is",
    "The president of the United States is", 
    "The capital of France is",
    "The future of AI is",
    "Can you write a poem about a cat?",
]

# Create a sampling params object.
sampling_params = SamplingParams(temperature=0.8, top_p=0.95, max_tokens=512)


def main():
    # Create an LLM using the local model path.
    llm = LLM(model=model_path)
    
    # Generate texts from the prompts.
    # The output is a list of RequestOutput objects
    # that contain the prompt, generated text, and other information.
    outputs = llm.generate(prompts, sampling_params)
    
    # Print the outputs.
    print("\nGenerated Outputs:\n" + "-" * 60)
    for output in outputs:
        prompt = output.prompt
        generated_text = output.outputs[0].text
        print(f"Prompt:    {prompt!r}")
        print(f"Output:    {generated_text!r}")
        print("-" * 60)


if __name__ == "__main__":
    main()
