import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import sessionmaker, declarative_base
from dotenv import load_dotenv
import os


# Database configuration
load_dotenv()
DATABASE_URL = f"postgresql://dbuser:{os.getenv('DB_PASSWORD')}@{os.getenv('DB_HOST')}/mydatabase"

# SQLAlchemy setup
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()

# Model
class Contact(Base):
    __tablename__ = "contacts"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    phone = Column(String, index=True, nullable=False)

# Create tables
Base.metadata.create_all(bind=engine)

# Initialize database with sample data if empty
def init_db():
    db = SessionLocal()
    if not db.query(Contact).first():
        sample_contacts = [
            Contact(name="Alice", email="alice@example.com", phone="123456789"),
            Contact(name="Bob", email="bob@example.com", phone="987654321"),
        ]
        db.add_all(sample_contacts)
        db.commit()
    db.close()


# Pydantic schemas
class ContactCreate(BaseModel):
    name: str
    email: str
    phone: str

class ContactResponse(ContactCreate):
    id: int
    class Config:
        orm_mode = True

# FastAPI app
app = FastAPI(title="Contacts API")
@app.on_event("startup")
def on_startup():
    init_db()

@app.get("/", status_code=200)
def root():
    return {"status": "OK"}

@app.get("/contacts", response_model=List[ContactResponse])
def read_contacts():
    db = SessionLocal()
    contacts = db.query(Contact).all()
    db.close()
    return contacts

@app.get("/contacts/{contact_id}", response_model=ContactResponse)
def read_contact(contact_id: int):
    db = SessionLocal()
    contact = db.query(Contact).filter(Contact.id == contact_id).first()
    db.close()
    if not contact:
        raise HTTPException(status_code=404, detail="Contact not found")
    return contact

@app.post("/contacts", response_model=ContactResponse)
def create_contact(contact: ContactCreate):
    db = SessionLocal()
    db_contact = Contact(**contact.dict())
    db.add(db_contact)
    db.commit()
    db.refresh(db_contact)
    db.close()
    return db_contact

@app.put("/contacts/{contact_id}", response_model=ContactResponse)
def update_contact(contact_id: int, contact: ContactCreate):
    db = SessionLocal()
    db_contact = db.query(Contact).filter(Contact.id == contact_id).first()
    if not db_contact:
        db.close()
        raise HTTPException(status_code=404, detail="Contact not found")
    for key, value in contact.dict().items():
        setattr(db_contact, key, value)
    db.commit()
    db.refresh(db_contact)
    db.close()
    return db_contact

@app.delete("/contacts/{contact_id}", response_model=ContactResponse)
def delete_contact(contact_id: int):
    db = SessionLocal()
    db_contact = db.query(Contact).filter(Contact.id == contact_id).first()
    if not db_contact:
        db.close()
        raise HTTPException(status_code=404, detail="Contact not found")
    db.delete(db_contact)
    db.commit()
    db.close()
    return db_contact
