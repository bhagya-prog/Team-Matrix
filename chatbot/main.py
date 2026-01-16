from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class ChatRequest(BaseModel):
    message: str

class ChatResponse(BaseModel):
    reply: str

# Dummy chatbot logic (replace with your actual code)
def chatbot_reply(user_message):
    return f"You said: {user_message}"

@app.post("/chat", response_model=ChatResponse)
def chat(req: ChatRequest):
    response = chatbot_reply(req.message)
    return {"reply": response}
