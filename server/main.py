from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

import logging
logging.basicConfig(level=logging.DEBUG)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

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
