from src.db.supabase_client import supabase

class OrganizationService:
    def __init__(self):
        self.db = supabase

    def list_organizations(self):
        response = self.db.table("organizations").select("*").execute()
        return response.data
    
    def create_organization(self, organization_data):
        response = self.db.table("organizations").insert(organization_data).execute()
        return response.data
    
    