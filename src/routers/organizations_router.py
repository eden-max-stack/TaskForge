from fastapi import APIRouter, status, Depends
from typing import List
from src.shared.dependencies import get_current_user
from src.models.organizations_models import OrganizationCreate, OrganizationResponse
from pydantic import BaseModel

from src.shared.models import APIResponse
from src.services.organizations_service import OrganizationService

router = APIRouter(prefix="/organizations", tags=["Organizations"])

@router.get("/", response_model=APIResponse[List[OrganizationResponse]], status_code=status.HTTP_200_OK)
def list_organizations_by_user(user_id: str = "63356513-a53a-4782-a9bf-7cdfd827a95b"):
    data = OrganizationService().list_organizations_by_user("63356513-a53a-4782-a9bf-7cdfd827a95b")
    return {
        "message": "Organizations for {user_id} fetched successfully",
        "data": data
    }

@router.post("/", response_model=APIResponse[OrganizationResponse], status_code=status.HTTP_201_CREATED)
def create_organization(organization_data: OrganizationCreate):
    data = OrganizationService().create_organization(organization_data)
    return {
        "message": "Organization created successfully.",
        "data": data
    }

