from src.models.authentication_models import LoginRequest, SignUpRequest
from src.db.supabase_client import supabase

class AuthenticationService:
    def __init__(self):
        self.db = supabase

    def login(self, login_data: LoginRequest):
        response = self.db.auth.sign_in_with_password({
            "email": login_data.email_id,
            "password": login_data.pswd
        })
        return response.data
    
    def sign_up(self, sign_up_data: SignUpRequest):
        response = self.db.auth.sign_up({
            "email": sign_up_data.email_id,
            "password": sign_up_data.pswd,
        })

        user_id = response.user.id

        response = self.db.table("users").insert({
            "user_id": user_id,
            "email_id": sign_up_data.email_id,
            "full_name": sign_up_data.first_name + " " + sign_up_data.last_name,
            "user_name": sign_up_data.user_name
        }).execute()

        return response.data[0]
