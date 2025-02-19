#!/bin/bash

# Project Name (adjust as needed)
PROJECT_NAME="accounting"

# Create Project Directory
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create Backend Directory and Files
mkdir backend
cd backend

# Create virtual environment (recommended for Python projects)
python3 -m venv venv  # Or python -m venv venv if python3 is not the default
source venv/bin/activate  # Activate the environment

# Install Backend Dependencies (example for Python/Flask)
pip install Flask psycopg2 # Add other dependencies as needed

# Create Backend Application Files
touch app.py  # Main application file
mkdir models templates # Database models and HTML templates
touch models/__init__.py templates/__init__.py

# Create sample app.py (replace with your actual code later)
cat << EOF > app.py
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello, Cloud Accounting!"

if __name__ == '__main__':
    app.run(debug=True)
EOF

# Create sample template (templates/index.html)
mkdir -p templates
cat << EOF > templates/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Cloud Accounting</title>
</head>
<body>
    <h1>Welcome to Cloud Accounting!</h1>
</body>
</html>
EOF

cd .. # Go back to the main project directory

# Create Frontend Directory and Files
mkdir frontend
cd frontend

# Install Frontend Dependencies (example for React)
npx create-react-app . # Creates a new React project in the current directory

# (Add your frontend code, components, etc., inside the frontend directory)


cd .. # Go back to the main project directory

# Create Database Setup Script (example for PostgreSQL)
cat << EOF > setup_database.sh
#!/bin/bash

# Database credentials (REPLACE with your actual credentials)
DB_HOST="localhost"
DB_NAME="aenzbi_db"
DB_USER="aenzbi_user"
DB_PASSWORD="strongPassword123"

# Connect to PostgreSQL
psql -h "\$DB_HOST" -U "\$DB_USER" -d postgres -c "CREATE DATABASE \\"\$DB_NAME\\""
psql -h "\$DB_HOST" -U "\$DB_USER" -d "\$DB_NAME" -c "CREATE USER \\"\$DB_USER\\" WITH PASSWORD '\\"\$DB_PASSWORD\\"';"
psql -h "\$DB_HOST" -U "\$DB_USER" -d "\$DB_NAME" -c "GRANT ALL PRIVILEGES ON DATABASE \\"\$DB_NAME\\" TO \\"\$DB_USER\\";"

# Create tables (add your SQL table creation statements here)
# Example:
# psql -h "\$DB_HOST" -U "\$DB_USER" -d "\$DB_NAME" -f create_tables.sql  # If you have a separate SQL file

echo "Database setup complete."
EOF

chmod +x setup_database.sh


# Create Sample SQL file (create_tables.sql)
cat << EOF > create_tables.sql
-- Example SQL table creation statements (replace with your actual schema)
CREATE TABLE IF NOT EXISTS invoices (
    id SERIAL PRIMARY KEY,
    invoice_number VARCHAR(255) NOT NULL,
    date DATE,
    amount DECIMAL,
    customer_id INTEGER
    -- ... other columns
);

-- Add other tables as needed (customers, products, etc.)
EOF

# Create Deployment Script (example for Cloud Run backend)
cat << EOF > deploy_backend.sh
#!/bin/bash

# Project ID and Region (REPLACE with your values)
PROJECT_ID="sokoni-44ef1"
REGION="south-africa1"

# Build and push Docker image (adjust path if needed)
docker build -t your-backend-image ./backend
gcloud container images push your-backend-image

# Deploy to Cloud Run
gcloud run deploy your-backend-service \
    --image your-backend-image \
    --region "\$REGION" \
    --platform managed \
    --project "\$PROJECT_ID" \
    --allow-unauthenticated # Restrict access in production!

echo "Backend deployed."
EOF

chmod +x deploy_backend.sh

# Create .gitignore file (to exclude virtual environment, node_modules, etc.)
cat << EOF > .gitignore
backend/venv
frontend/node_modules
.DS_Store
EOF


echo "Project setup complete.  See the README.md file for next steps."

# Create a README with instructions
cat << EOF > README.md
# Cloud Accounting Project

This project contains a basic structure for a cloud accounting system.

## Getting Started

1.  Set up your Google Cloud project and enable the necessary APIs (Compute Engine, Cloud SQL, etc.).

2.  Run the \`setup_database.sh\` script to create the database and user.  **Update the database credentials in the script first!**

3.  Activate the backend virtual environment: \`source backend/venv/bin/activate\`

4.  Install backend dependencies: \`pip install -r requirements.txt\` (Create requirements.txt if you have other packages)

5.  Start the backend development server: \`python backend/app.py\`

6.  Navigate to the frontend directory: \`cd frontend\`

7.  Start the frontend development server: \`npm start\` (or yarn start)

8.  Run the \`deploy_backend.sh\` script to deploy the backend to Cloud Run. **Update the project ID and region in the script first!**

## Project Structure

*   \`backend\`: Contains the backend application (Python/Flask).
*   \`frontend\`: Contains the frontend application (React).
*   \`setup_database.sh\`: Script to set up the PostgreSQL database.
*   \`deploy_backend.sh\`: Script to deploy the backend to Cloud Run.
*   \`create_tables.sql\`: SQL file containing table creation statements.

## Next Steps

*   Implement the actual accounting logic in the backend.
*   Develop the frontend UI for interacting with the backend.
*   Configure proper authentication and authorization.
*   Add comprehensive testing.
*   Set up CI/CD pipelines for automated deployment.
*   ... and much more!
EOF
