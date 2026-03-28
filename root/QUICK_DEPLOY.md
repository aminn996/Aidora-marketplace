# 🚀 Quick Deployment Guide - Aidora Marketplace

This is a streamlined guide to deploy your Aidora marketplace web application in under 30 minutes.

## 🎯 Choose Your Deployment Path

| Platform | Time | Cost | Best For |
|----------|------|------|----------|
| **[Vercel + Render](#option-1-vercel--render)** | 15 min | Free/Paid | Quick start, auto-scaling |
| **[Netlify + Railway](#option-2-netlify--railway)** | 15 min | Free/Paid | Simple setup, great DX |
| **[Docker](#option-3-docker)** | 20 min | Varies | Full control, any platform |
| **[VPS](#option-4-vps)** | 30 min | $5-20/mo | Maximum control, custom config |

---

## ✅ Prerequisites (5 minutes)

Before you start, make sure you have:

1. **MongoDB Atlas Account** (free)
   - Sign up at [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
   - Create a free M0 cluster
   - Get your connection string

2. **Gmail Account** with App Password
   - Enable 2FA
   - Generate App Password: [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)

3. **Google OAuth Credentials**
   - Go to [console.cloud.google.com](https://console.cloud.google.com)
   - Create project → Enable Google+ API → Create OAuth client

4. **Facebook OAuth Credentials**
   - Go to [developers.facebook.com](https://developers.facebook.com)
   - Create app → Add Facebook Login → Get App ID and Secret

---

## Option 1: Vercel + Render

### Backend on Render (8 minutes)

1. **Sign up at [render.com](https://render.com)** with GitHub

2. **Create Web Service**
   - Click "New +" → "Web Service"
   - Connect your repository
   - Configure:
     ```
     Name: aidora-backend
     Root Directory: root/backend
     Build Command: npm install
     Start Command: npm start
     ```

3. **Add Environment Variables**
   ```env
   NODE_ENV=production
   MONGO_URI=your-mongodb-connection-string
   JWT_SECRET=your-32-character-secret-key
   PORT=5000
   BACKEND_URL=https://aidora-backend.onrender.com
   FRONTEND_URL=https://your-app.vercel.app
   EMAIL_USER=your-email@gmail.com
   EMAIL_PASSWORD=your-16-char-app-password
   GOOGLE_CLIENT_ID=your-google-client-id
   GOOGLE_CLIENT_SECRET=your-google-secret
   FACEBOOK_APP_ID=your-facebook-app-id
   FACEBOOK_APP_SECRET=your-facebook-secret
   ```

4. **Deploy** - Note your URL: `https://aidora-backend.onrender.com`

### Frontend on Vercel (7 minutes)

1. **Sign up at [vercel.com](https://vercel.com)** with GitHub

2. **Import Project**
   - Click "Add New" → "Project"
   - Import your repository

3. **Configure**
   ```
   Framework: Vite
   Root Directory: root/frontend
   Build Command: npm run build
   Output Directory: dist
   ```

4. **Add Environment Variables**
   ```env
   VITE_API_URL=https://aidora-backend.onrender.com/api
   VITE_GOOGLE_CLIENT_ID=your-google-client-id
   VITE_FACEBOOK_APP_ID=your-facebook-app-id
   ```

5. **Deploy** - Your app is live!

6. **Update Backend**
   - Go back to Render
   - Update `FRONTEND_URL` to your Vercel URL
   - Redeploy

### Configure OAuth Callbacks

Update your OAuth redirect URIs:

**Google Console:**
- Add: `https://aidora-backend.onrender.com/api/auth/google/callback`

**Facebook Console:**
- Add: `https://aidora-backend.onrender.com/api/auth/facebook/callback`

---

## Option 2: Netlify + Railway

### Backend on Railway (8 minutes)

1. **Sign up at [railway.app](https://railway.app)**

2. **New Project**
   - Click "New Project" → "Deploy from GitHub repo"
   - Select your repository

3. **Configure**
   - Set root directory: `root/backend`
   - Add start command: `npm start`

4. **Add Environment Variables** (same as Render above)

5. **Generate Domain**
   - Go to Settings → Generate Domain
   - Note your URL: `https://your-app.up.railway.app`

### Frontend on Netlify (7 minutes)

1. **Sign up at [netlify.com](https://netlify.com)**

2. **New Site**
   - "Add new site" → "Import an existing project"
   - Choose GitHub → Select repository

3. **Build Settings**
   ```
   Base directory: root/frontend
   Build command: npm run build
   Publish directory: root/frontend/dist
   ```

4. **Environment Variables**
   ```env
   VITE_API_URL=https://your-app.up.railway.app/api
   VITE_GOOGLE_CLIENT_ID=your-google-client-id
   VITE_FACEBOOK_APP_ID=your-facebook-app-id
   ```

5. **Deploy** - Site is live!

6. **Update Backend** - Set `FRONTEND_URL` in Railway to your Netlify URL

---

## Option 3: Docker

### Quick Docker Deploy (20 minutes)

1. **Install Docker** and Docker Compose

2. **Create .env file** in `root/` directory:
   ```env
   # Copy all environment variables from above
   MONGO_URI=your-mongodb-connection-string
   JWT_SECRET=your-secret
   BACKEND_URL=http://localhost:5000
   FRONTEND_URL=http://localhost
   # ... add all other variables
   ```

3. **Build and Run**
   ```bash
   cd root
   docker-compose up -d
   ```

4. **Access Application**
   - Frontend: http://localhost
   - Backend: http://localhost:5000

5. **Deploy to Cloud**
   
   **AWS ECS:**
   ```bash
   # Install AWS CLI and configure
   aws ecr create-repository --repository-name aidora-backend
   aws ecr create-repository --repository-name aidora-frontend
   
   # Push images
   docker tag aidora-backend:latest YOUR_ECR_URL/aidora-backend:latest
   docker push YOUR_ECR_URL/aidora-backend:latest
   
   # Create ECS cluster and services via console
   ```

   **Google Cloud Run:**
   ```bash
   gcloud builds submit --tag gcr.io/PROJECT_ID/aidora-backend backend/
   gcloud run deploy aidora-backend \
     --image gcr.io/PROJECT_ID/aidora-backend \
     --platform managed \
     --region us-central1 \
     --allow-unauthenticated
   ```

---

## Option 4: VPS (DigitalOcean, AWS EC2)

### Deploy to VPS (30 minutes)

1. **Create Droplet/Instance**
   - Ubuntu 22.04 LTS
   - Minimum: 2GB RAM

2. **SSH into Server**
   ```bash
   ssh root@your-server-ip
   ```

3. **Install Dependencies**
   ```bash
   # Update system
   apt update && apt upgrade -y
   
   # Install Node.js 18
   curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
   apt install -y nodejs
   
   # Install PM2
   npm install -g pm2
   
   # Install Nginx
   apt install -y nginx
   
   # Install Certbot for SSL
   apt install -y certbot python3-certbot-nginx
   ```

4. **Clone and Setup**
   ```bash
   cd /var/www
   git clone https://github.com/your-username/aidora-marketplace.git
   cd aidora-marketplace/root
   
   # Backend
   cd backend
   npm install
   cp .env.example .env
   nano .env  # Edit with your values
   pm2 start server.js --name aidora-backend
   pm2 save
   pm2 startup
   
   # Frontend
   cd ../frontend
   npm install
   cp .env.example .env
   nano .env  # Edit with your values
   npm run build
   ```

5. **Configure Nginx**
   ```bash
   nano /etc/nginx/sites-available/aidora
   ```
   
   Paste configuration:
   ```nginx
   server {
       listen 80;
       server_name yourdomain.com;
       
       location /api {
           proxy_pass http://localhost:5000/api;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
       
       location / {
           root /var/www/aidora-marketplace/root/frontend/dist;
           try_files $uri $uri/ /index.html;
       }
   }
   ```
   
   Enable site:
   ```bash
   ln -s /etc/nginx/sites-available/aidora /etc/nginx/sites-enabled/
   nginx -t
   systemctl restart nginx
   ```

6. **Setup SSL**
   ```bash
   certbot --nginx -d yourdomain.com -d www.yourdomain.com
   ```

7. **Configure Firewall**
   ```bash
   ufw allow 22/tcp
   ufw allow 80/tcp
   ufw allow 443/tcp
   ufw enable
   ```

---

## 🧪 Test Your Deployment

After deployment, test these features:

1. **Health Check**
   ```bash
   curl https://your-backend-url/api/health
   # Should return: {"status":"ok"}
   ```

2. **Frontend Access**
   - Visit your frontend URL
   - Should see homepage

3. **Authentication**
   - Sign in with Google
   - Sign in with Facebook
   - Create account with email

4. **Booking Flow**
   - Browse services
   - Create a booking
   - Check email notification

---

## 🔧 Common Issues

### Issue: CORS Error
**Solution:** Check that `FRONTEND_URL` in backend matches your actual frontend domain

### Issue: OAuth Fails
**Solution:** Verify redirect URIs in Google/Facebook console match your backend URL exactly

### Issue: Email Not Sending
**Solution:** Ensure you're using Gmail App Password, not regular password

### Issue: MongoDB Connection Failed
**Solution:** Whitelist your backend server IP in MongoDB Atlas Network Access

---

## 📊 Cost Summary

### Free Tier (Testing/MVP)
- Frontend: Vercel/Netlify Free
- Backend: Render/Railway Free (with limitations)
- Database: MongoDB Atlas M0 Free
- **Total: $0/month**

### Production Tier
- Frontend: Vercel Pro ($20/mo)
- Backend: Render Standard ($7/mo)
- Database: MongoDB M10 ($57/mo)
- **Total: ~$84/month**

### VPS Option
- DigitalOcean Droplet ($12/mo)
- MongoDB Atlas M10 ($57/mo)
- Domain ($12/year)
- **Total: ~$70/month**

---

## 🎉 You're Done!

Your Aidora marketplace is now live! 

### Next Steps:
1. ✅ Add custom domain
2. ✅ Set up monitoring (Sentry, LogRocket)
3. ✅ Configure backups
4. ✅ Add analytics
5. ✅ Set up CI/CD (see `.github/workflows/deploy.yml`)

### Get Help:
- 📖 Full Guide: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- 💬 GitHub Issues: Report problems
- 📧 Email: support@yourdomain.com

---

**Made with ❤️ for the Aidora community**
