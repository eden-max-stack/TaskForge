from pydantic import BaseModel

class LoginRequest(BaseModel):
    email_id: str
    pswd: str

class SignUpRequest(BaseModel):
    user_name: str
    email_id: str
    first_name: str
    last_name: str
    pswd: str