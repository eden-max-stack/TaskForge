from src.models.organizations_models import OrganizationCreate
from src.db.supabase_client import supabase

class OrganizationService:
    def __init__(self):
        self.db = supabase
    
    def list_organizations_by_user(self, user_id: str):
        response = self.db.table("org_users").select("*").eq("user_id", user_id).execute()
        return response.data
    
    def create_organization(self, organization_data: OrganizationCreate):
        response = self.db.table("organizations").insert({
            "org_name": organization_data.org_name
        }).execute()
        return response.data[0]
    
