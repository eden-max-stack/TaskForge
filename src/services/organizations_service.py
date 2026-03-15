from src.models.organizations_models import OrganizationCreate
from src.db.supabase_client import supabase

class OrganizationService:
    def __init__(self):
        self.db = supabase

    def list_organizations(self):
        response = self.db.table("organizations").select("*").execute()
        return response.data
    
    def create_organization(self, organization_data: OrganizationCreate):
        response = self.db.table("organizations").insert({
            "org_name": organization_data.org_name
        }).execute()
        return response.data[0]
    
