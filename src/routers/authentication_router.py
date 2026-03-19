from fastapi import APIRouter, status
from pydantic import BaseModel
from src.models.authentication_models import LoginRequest, SignUpRequest
from src.services.authentication_service import AuthenticationService
from src.shared.models import APIResponse

router = APIRouter(prefix="/auth", tags=["Authentication"])

class LoginResponse(BaseModel):
    user_id: str

class SignUpResponse(BaseModel):
    user_id: str
    user_name: str
    email_id: str
    full_name: str
    created_at: str

@router.post("/login", response_model=APIResponse[LoginResponse], status_code=status.HTTP_200_OK)
def login(login_data: LoginRequest):
    data = AuthenticationService().login(login_data)
    return {
        "message": "Login successful.",
        "data": data
    }

@router.post("/sign-up", response_model=APIResponse[SignUpResponse], status_code=status.HTTP_201_CREATED)
def sign_up(sign_up_data: SignUpRequest):
    data = AuthenticationService().sign_up(sign_up_data)
    return {
        "message": "Sign-up successful.",
        "data": data
    }