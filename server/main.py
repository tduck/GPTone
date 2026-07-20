from fastapi import FastAPI
from pydantic import BaseModel

import logging
logging.basicConfig(level=logging.DEBUG)

app = FastAPI()

class EchoRequest(BaseModel):
    message: str

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/echo")
def echo(request: EchoRequest):
    return {"echo": request.message}

@app.post("/api/generate_tone")
def generate_tone(description: str):
    return {
        "preset_name": f"Generated: {description}",
        "effects": [
            {"type": "reverb", "enabled": True, "mix": 0.5, "time": 2.5, "damping": 0.7}
        ]
    }
