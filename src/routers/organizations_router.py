from fastapi import APIRouter, status
from typing import List
from pydantic import BaseModel

from src.shared.models import APIResponse
from src.services.organizations_service import OrganizationService

router = APIRouter(prefix="/organizations", tags=["Organizations"])

class OrganizationResponse(BaseModel):
    org_id: str
    org_name: str
    created_at: str

@router.get("/", response_model=APIResponse[List[OrganizationResponse]], status_code=status.HTTP_200_OK)
def list_organizations():
    data = OrganizationService().list_organizations()
    return {
        "message": "Organizations fetched successfully.",
        "data": data
    }

@router.post("/", response_model=APIResponse[OrganizationResponse], status_code=status.HTTP_201_CREATED)
def create_organization():
    data = OrganizationService.create_organization()
    return {
        "message": "Organization created successfully.",
        "data": data
    }

