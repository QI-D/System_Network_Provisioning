# Docker Project for ACIT4640 - System/Network Provisioning

Provision a Flask app using Docker and Docker Compose.

Docker Compose file contains 3 services:

- db (MySQL Database)
  - Database, User, Password defined in variables.env
- web (Frontend + Nginx)
  - Depends on database service
  - Download frontend files from repo
  - Configure Nginx
- app (Backend)
  - Depends on database service
  - Dowload backend files from repo
  - Start the app by running Gunicorn
  - Send initial data once gunicorn is running
