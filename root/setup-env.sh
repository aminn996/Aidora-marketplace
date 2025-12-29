#!/bin/bash

# Aidora Marketplace - Environment Setup Script
# This script helps you set up environment variables for deployment

set -e

echo "🚀 Aidora Marketplace - Environment Setup"
echo "=========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to generate random JWT secret
generate_jwt_secret() {
    openssl rand -base64 32
}

# Function to prompt for input
prompt() {
    local var_name=$1
    local prompt_text=$2
    local default_value=$3
    
    if [ -n "$default_value" ]; then
        read -p "$prompt_text [$default_value]: " value
        echo "${value:-$default_value}"
    else
        read -p "$prompt_text: " value
        echo "$value"
    fi
}

echo -e "${BLUE}Backend Environment Configuration${NC}"
echo "-----------------------------------"
echo ""

# MongoDB
MONGO_URI=$(prompt "MONGO_URI" "Enter your MongoDB connection string")

# JWT Secret
echo ""
echo "Generating JWT secret..."
JWT_SECRET=$(generate_jwt_secret)
echo -e "${GREEN}✓ Generated JWT secret${NC}"

# Server URLs
echo ""
BACKEND_URL=$(prompt "BACKEND_URL" "Enter your backend URL" "http://localhost:5000")
FRONTEND_URL=$(prompt "FRONTEND_URL" "Enter your frontend URL" "http://localhost:5173")

# Email Configuration
echo ""
echo -e "${YELLOW}Email Configuration (Gmail)${NC}"
EMAIL_USER=$(prompt "EMAIL_USER" "Enter your Gmail address")
EMAIL_PASSWORD=$(prompt "EMAIL_PASSWORD" "Enter your Gmail App Password (16 characters)")

# Google OAuth
echo ""
echo -e "${YELLOW}Google OAuth Configuration${NC}"
GOOGLE_CLIENT_ID=$(prompt "GOOGLE_CLIENT_ID" "Enter your Google Client ID")
GOOGLE_CLIENT_SECRET=$(prompt "GOOGLE_CLIENT_SECRET" "Enter your Google Client Secret")

# Facebook OAuth
echo ""
echo -e "${YELLOW}Facebook OAuth Configuration${NC}"
FACEBOOK_APP_ID=$(prompt "FACEBOOK_APP_ID" "Enter your Facebook App ID")
FACEBOOK_APP_SECRET=$(prompt "FACEBOOK_APP_SECRET" "Enter your Facebook App Secret")

# Admin credentials (optional)
echo ""
echo -e "${YELLOW}Admin Configuration (Optional)${NC}"
ADMIN_EMAIL=$(prompt "ADMIN_EMAIL" "Enter admin email" "admin@aidora.com")
ADMIN_PASSWORD=$(prompt "ADMIN_PASSWORD" "Enter admin password" "change-this-password")

# Create backend .env file
echo ""
echo "Creating backend/.env file..."
cat > backend/.env << EOF
# MongoDB
MONGO_URI=$MONGO_URI

# JWT
JWT_SECRET=$JWT_SECRET

# Server
PORT=5000
NODE_ENV=production
BACKEND_URL=$BACKEND_URL
FRONTEND_URL=$FRONTEND_URL

# Email Configuration (Gmail)
EMAIL_USER=$EMAIL_USER
EMAIL_PASSWORD=$EMAIL_PASSWORD

# Google OAuth
GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET=$GOOGLE_CLIENT_SECRET

# Facebook OAuth
FACEBOOK_APP_ID=$FACEBOOK_APP_ID
FACEBOOK_APP_SECRET=$FACEBOOK_APP_SECRET

# Admin
ADMIN_EMAIL=$ADMIN_EMAIL
ADMIN_PASSWORD=$ADMIN_PASSWORD
EOF

echo -e "${GREEN}✓ Created backend/.env${NC}"

# Create frontend .env file
echo ""
echo "Creating frontend/.env file..."
cat > frontend/.env << EOF
# Backend API URL
VITE_API_URL=$BACKEND_URL/api

# Google OAuth
VITE_GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID

# Facebook OAuth
VITE_FACEBOOK_APP_ID=$FACEBOOK_APP_ID
EOF

echo -e "${GREEN}✓ Created frontend/.env${NC}"

# Display summary
echo ""
echo "=========================================="
echo -e "${GREEN}✓ Environment setup complete!${NC}"
echo "=========================================="
echo ""
echo "📝 Summary:"
echo "  - Backend .env: ./backend/.env"
echo "  - Frontend .env: ./frontend/.env"
echo ""
echo "📋 Next Steps:"
echo "  1. Review the generated .env files"
echo "  2. Update OAuth redirect URIs:"
echo "     - Google: $BACKEND_URL/api/auth/google/callback"
echo "     - Facebook: $BACKEND_URL/api/auth/facebook/callback"
echo "  3. Start your application:"
echo "     - Backend: cd backend && npm start"
echo "     - Frontend: cd frontend && npm run dev"
echo ""
echo "🔒 Security Note:"
echo "  - Keep your .env files secure"
echo "  - Never commit .env files to Git"
echo "  - Use different secrets for production"
echo ""
