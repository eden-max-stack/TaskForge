from pydantic import BaseModel

class OrganizationResponse(BaseModel):
    org_id: str
    org_name: str
    created_at: str

class OrganizationCreate(BaseModel):
    org_name: str