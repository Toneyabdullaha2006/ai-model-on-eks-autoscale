from fastapi import FastAPI
from pydantic import BaseModel
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch

app = FastAPI()
model_id = "TinyLlama/TinyLlama-1.1B-Chat-v1.0"
tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(model_id, torch_dtype=torch.float32)

class Prompt(BaseModel):
    prompt: str
    max_tokens: int = 100

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/generate")
def generate(p: Prompt):
    inputs = tokenizer(p.prompt, return_tensors="pt")
    out = model.generate(**inputs, max_new_tokens=p.max_tokens)
    return {"response": tokenizer.decode(out[0], skip_special_tokens=True)}