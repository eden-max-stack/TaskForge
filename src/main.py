from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from src.routers.organizations_router import router as organizations_router

app = FastAPI(title="TaskForge backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

app.include_router(organizations_router)