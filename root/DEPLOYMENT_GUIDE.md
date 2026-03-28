# 🚀 Aidora Marketplace - Deployment Guide

This comprehensive guide covers deploying the Aidora marketplace web application to various platforms. Choose the deployment option that best fits your needs.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Variables](#environment-variables)
3. [Deployment Options](#deployment-options)
   - [Option 1: Vercel (Frontend) + Render (Backend)](#option-1-vercel-frontend--render-backend)
   - [Option 2: Netlify (Frontend) + Railway (Backend)](#option-2-netlify-frontend--railway-backend)
   - [Option 3: Docker + Cloud Platforms](#option-3-docker--cloud-platforms)
   - [Option 4: Traditional VPS (DigitalOcean, AWS EC2)](#option-4-traditional-vps-digitalocean-aws-ec2)
4. [Database Setup](#database-setup)
5. [OAuth Configuration](#oauth-configuration)
6. [Post-Deployment Checklist](#post-deployment-checklist)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before deploying, ensure you have:

- ✅ **Git repository** with your code
- ✅ **MongoDB Atlas** account (free tier available)
- ✅ **Gmail account** with 2FA and App Password
- ✅ **Google OAuth credentials** (from Google Cloud Console)
- ✅ **Facebook OAuth credentials** (from Facebook Developers)
- ✅ **Domain name** (optional but recommended)
- ✅ **SSL certificate** (usually provided by hosting platforms)

---

## Environment Variables

### Backend Environment Variables

Create these environment variables in your backend hosting platform:

```env
# Database
MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/aidora?retryWrites=true&w=majority

# JWT
JWT_SECRET=your-super-secret-jwt-key-minimum-32-characters-long

# Server Configuration
PORT=5000
NODE_ENV=production
BACKEND_URL=https://your-backend-domain.com
FRONTEND_URL=https://your-frontend-domain.com

# Email Configuration (Gmail)
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-16-character-app-password

# Google OAuth
GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-client-secret

# Facebook OAuth
FACEBOOK_APP_ID=your-facebook-app-id
FACEBOOK_APP_SECRET=your-facebook-app-secret

# Admin (Optional)
ADMIN_EMAIL=admin@aidora.com
ADMIN_PASSWORD=secure-admin-password
```

### Frontend Environment Variables

Create these environment variables in your frontend hosting platform:

```env
# Backend API URL (point to your deployed backend)
VITE_API_URL=https://your-backend-domain.com/api

# Google OAuth (same Client ID as backend)
VITE_GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com

# Facebook OAuth (same App ID as backend)
VITE_FACEBOOK_APP_ID=your-facebook-app-id
```

---

## Deployment Options

### Option 1: Vercel (Frontend) + Render (Backend)

**Best for:** Quick deployment with free tier, automatic HTTPS, and zero configuration.

#### Step 1: Deploy Backend to Render

1. **Create Render Account**
   - Go to [render.com](https://render.com)
   - Sign up with GitHub

2. **Create New Web Service**
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Select the repository

3. **Configure Web Service**
   ```
   Name: aidora-backend
   Region: Choose closest to your users
   Branch: main
   Root Directory: root/backend
   Runtime: Node
   Build Command: npm install
   Start Command: npm start
   ```

4. **Add Environment Variables**
   - Go to "Environment" tab
   - Add all backend environment variables listed above
   - Set `NODE_ENV=production`
   - Set `BACKEND_URL=https://aidora-backend.onrender.com` (or your custom domain)

5. **Deploy**
   - Click "Create Web Service"
   - Wait for deployment (5-10 minutes)
   - Note your backend URL: `https://aidora-backend.onrender.com`

#### Step 2: Deploy Frontend to Vercel

1. **Install Vercel CLI** (optional)
   ```bash
   npm install -g vercel
   ```

2. **Deploy via Vercel Dashboard**
   - Go to [vercel.com](https://vercel.com)
   - Click "Add New" → "Project"
   - Import your GitHub repository
   - Select repository

3. **Configure Project**
   ```
   Framework Preset: Vite
   Root Directory: root/frontend
   Build Command: npm run build
   Output Directory: dist
   Install Command: npm install
   ```

4. **Add Environment Variables**
   - Go to "Settings" → "Environment Variables"
   - Add:
     - `VITE_API_URL` = Your Render backend URL + `/api`
     - `VITE_GOOGLE_CLIENT_ID` = Your Google Client ID
     - `VITE_FACEBOOK_APP_ID` = Your Facebook App ID

5. **Deploy**
   - Click "Deploy"
   - Wait for build (2-5 minutes)
   - Your app will be live at: `https://your-project.vercel.app`

6. **Update Backend URL**
   - Go back to Render
   - Update `FRONTEND_URL` environment variable to your Vercel URL
   - Redeploy backend

---

### Option 2: Netlify (Frontend) + Railway (Backend)

**Best for:** Simple deployments with generous free tier and great DX.

#### Step 1: Deploy Backend to Railway

1. **Create Railway Account**
   - Go to [railway.app](https://railway.app)
   - Sign up with GitHub

2. **Create New Project**
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose your repository

3. **Configure Service**
   - Railway will auto-detect Node.js
   - Set root directory to `root/backend`
   - Add a start command: `npm start`

4. **Add Environment Variables**
   - Click on your service
   - Go to "Variables" tab
   - Add all backend environment variables
   - Railway provides `PORT` automatically

5. **Generate Domain**
   - Go to "Settings" tab
   - Click "Generate Domain"
   - Note your URL: `https://your-app.up.railway.app`

#### Step 2: Deploy Frontend to Netlify

1. **Create Netlify Account**
   - Go to [netlify.com](https://netlify.com)
   - Sign up with GitHub

2. **New Site from Git**
   - Click "Add new site" → "Import an existing project"
   - Choose GitHub
   - Select your repository

3. **Build Settings**
   ```
   Base directory: root/frontend
   Build command: npm run build
   Publish directory: root/frontend/dist
   ```

4. **Environment Variables**
   - Go to "Site settings" → "Environment variables"
   - Add:
     - `VITE_API_URL` = Your Railway backend URL + `/api`
     - `VITE_GOOGLE_CLIENT_ID` = Your Google Client ID
     - `VITE_FACEBOOK_APP_ID` = Your Facebook App ID

5. **Deploy Site**
   - Click "Deploy site"
   - Wait for deployment
   - Your site: `https://your-site.netlify.app`

6. **Update Backend**
   - Update Railway's `FRONTEND_URL` to your Netlify URL
   - Redeploy

---

### Option 3: Docker + Cloud Platforms

**Best for:** Containerized deployments, microservices, and scalability.

#### Step 1: Create Docker Files

See the `Dockerfile` and `docker-compose.yml` files in the root directory.

#### Step 2: Build and Test Locally

```bash
# Build images
docker-compose build

# Run containers
docker-compose up -d

# Check logs
docker-compose logs -f

# Stop containers
docker-compose down
```

#### Step 3: Deploy to Cloud Platform

**For AWS ECS:**
1. Push images to ECR
2. Create ECS cluster
3. Create task definitions
4. Create services
5. Configure load balancer

**For Google Cloud Run:**
```bash
# Build and push
gcloud builds submit --tag gcr.io/PROJECT_ID/aidora-backend
gcloud builds submit --tag gcr.io/PROJECT_ID/aidora-frontend

# Deploy
gcloud run deploy aidora-backend --image gcr.io/PROJECT_ID/aidora-backend
gcloud run deploy aidora-frontend --image gcr.io/PROJECT_ID/aidora-frontend
```

**For Azure Container Instances:**
```bash
# Create resource group
az group create --name aidora-rg --location eastus

# Deploy containers
az container create --resource-group aidora-rg \
  --name aidora-backend \
  --image your-registry/aidora-backend:latest \
  --dns-name-label aidora-backend
```

---

### Option 4: Traditional VPS (DigitalOcean, AWS EC2)

**Best for:** Full control, custom configurations, and cost optimization.

#### Step 1: Set Up VPS

1. **Create Droplet/Instance**
   - Choose Ubuntu 22.04 LTS
   - Minimum: 2GB RAM, 1 CPU
   - Recommended: 4GB RAM, 2 CPU

2. **SSH into Server**
   ```bash
   ssh root@your-server-ip
   ```

3. **Update System**
   ```bash
   apt update && apt upgrade -y
   ```

4. **Install Node.js**
   ```bash
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   apt install -y nodejs
   node --version
   npm --version
   ```

5. **Install PM2**
   ```bash
   npm install -g pm2
   ```

6. **Install Nginx**
   ```bash
   apt install -y nginx
   ```

#### Step 2: Deploy Application

1. **Clone Repository**
   ```bash
   cd /var/www
   git clone https://github.com/your-username/aidora-marketplace.git
   cd aidora-marketplace/root
   ```

2. **Set Up Backend**
   ```bash
   cd backend
   npm install
   cp .env.example .env
   nano .env  # Edit with your production values
   ```

3. **Start Backend with PM2**
   ```bash
   pm2 start server.js --name aidora-backend
   pm2 save
   pm2 startup
   ```

4. **Build Frontend**
   ```bash
   cd ../frontend
   npm install
   cp .env.example .env
   nano .env  # Edit with your production values
   npm run build
   ```

#### Step 3: Configure Nginx

1. **Create Nginx Config**
   ```bash
   nano /etc/nginx/sites-available/aidora
   ```

2. **Add Configuration**
   ```nginx
   # Backend API
   server {
       listen 80;
       server_name api.yourdomain.com;

       location / {
           proxy_pass http://localhost:5000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       }
   }

   # Frontend
   server {
       listen 80;
       server_name yourdomain.com www.yourdomain.com;
       root /var/www/aidora-marketplace/root/frontend/dist;
       index index.html;

       location / {
           try_files $uri $uri/ /index.html;
       }

       # Cache static assets
       location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
           expires 1y;
           add_header Cache-Control "public, immutable";
       }
   }
   ```

3. **Enable Site**
   ```bash
   ln -s /etc/nginx/sites-available/aidora /etc/nginx/sites-enabled/
   nginx -t
   systemctl restart nginx
   ```

#### Step 4: Set Up SSL with Let's Encrypt

```bash
# Install Certbot
apt install -y certbot python3-certbot-nginx

# Get SSL certificate
certbot --nginx -d yourdomain.com -d www.yourdomain.com -d api.yourdomain.com

# Auto-renewal
certbot renew --dry-run
```

#### Step 5: Configure Firewall

```bash
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

---

## Database Setup

### MongoDB Atlas (Recommended)

1. **Create Cluster**
   - Go to [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
   - Create free cluster (M0)
   - Choose region closest to your backend

2. **Create Database User**
   - Go to "Database Access"
   - Add new user with password
   - Note username and password

3. **Configure Network Access**
   - Go to "Network Access"
   - For development: Allow access from anywhere (0.0.0.0/0)
   - For production: Add your backend server IP

4. **Get Connection String**
   - Go to "Database" → "Connect"
   - Choose "Connect your application"
   - Copy connection string
   - Replace `<password>` with your password
   - Replace `<dbname>` with `aidora`

5. **Test Connection**
   ```bash
   cd backend
   node scripts/testMongoPing.js
   ```

---

## OAuth Configuration

### Google OAuth Setup

1. **Create Project**
   - Go to [console.cloud.google.com](https://console.cloud.google.com)
   - Create new project: "Aidora Marketplace"

2. **Enable APIs**
   - Go to "APIs & Services" → "Library"
   - Enable "Google+ API"

3. **Create OAuth Credentials**
   - Go to "Credentials"
   - Create "OAuth client ID"
   - Application type: "Web application"

4. **Configure URLs**
   - Authorized JavaScript origins:
     - `https://yourdomain.com`
     - `http://localhost:5173` (for development)
   - Authorized redirect URIs:
     - `https://your-backend.com/api/auth/google/callback`
     - `http://localhost:5000/api/auth/google/callback` (for development)

5. **Get Credentials**
   - Copy Client ID and Client Secret
   - Add to backend and frontend environment variables

### Facebook OAuth Setup

1. **Create App**
   - Go to [developers.facebook.com](https://developers.facebook.com)
   - Create new app
   - Choose "Consumer" type

2. **Add Facebook Login**
   - Go to "Add Product"
   - Add "Facebook Login"

3. **Configure OAuth**
   - Go to "Facebook Login" → "Settings"
   - Valid OAuth Redirect URIs:
     - `https://your-backend.com/api/auth/facebook/callback`
     - `http://localhost:5000/api/auth/facebook/callback` (for development)

4. **Get Credentials**
   - Go to "Settings" → "Basic"
   - Copy App ID and App Secret
   - Add to environment variables

5. **Make App Live**
   - Go to "App Review"
   - Make app public

---

## Post-Deployment Checklist

After deploying, verify these items:

- [ ] **Backend Health Check**
  ```bash
  curl https://your-backend.com/api/health
  # Should return: {"status":"ok"}
  ```

- [ ] **Database Connection**
  - Check backend logs
  - Should see "MongoDB connected" message

- [ ] **Frontend Loads**
  - Visit your frontend URL
  - Should see homepage

- [ ] **Authentication Works**
  - [ ] Email/password registration
  - [ ] Email/password login
  - [ ] Google OAuth login
  - [ ] Facebook OAuth login

- [ ] **Email Notifications**
  - [ ] Create test booking
  - [ ] Provider receives email
  - [ ] Accept booking
  - [ ] Customer receives confirmation

- [ ] **API Endpoints**
  - [ ] GET /api/services (list services)
  - [ ] POST /api/bookings (create booking)
  - [ ] GET /api/auth/me (get user profile)

- [ ] **Security**
  - [ ] HTTPS enabled
  - [ ] Environment variables secured
  - [ ] CORS configured correctly
  - [ ] Rate limiting active

- [ ] **Performance**
  - [ ] Frontend loads < 3 seconds
  - [ ] API responses < 500ms
  - [ ] Images optimized

---

## Troubleshooting

### Common Issues and Solutions

#### 1. CORS Errors

**Problem:** Frontend can't connect to backend

**Solution:**
```javascript
// backend/server.js - Update CORS configuration
app.use(cors({
  origin: process.env.FRONTEND_URL,
  credentials: true
}));
```

#### 2. MongoDB Connection Failed

**Problem:** Cannot connect to database

**Solutions:**
- Verify MONGO_URI format is correct
- Check MongoDB Atlas network access (whitelist IP)
- Ensure database user has correct permissions
- Test connection string locally

#### 3. OAuth Redirect Errors

**Problem:** OAuth login fails with redirect error

**Solutions:**
- Verify callback URLs in Google/Facebook console match exactly
- Check environment variables are correct
- Ensure BACKEND_URL and FRONTEND_URL are set correctly
- Clear browser cache and cookies

#### 4. Email Not Sending

**Problem:** Booking emails not delivered

**Solutions:**
- Verify Gmail 2FA is enabled
- Generate new App Password (not regular password)
- Check EMAIL_USER and EMAIL_PASSWORD are correct
- Test with a different email provider

#### 5. Build Fails on Vercel/Netlify

**Problem:** Build fails during deployment

**Solutions:**
- Check build logs for specific errors
- Verify all dependencies are in package.json
- Ensure correct Node version (18+)
- Check build command is correct
- Clear cache and redeploy

#### 6. 502 Bad Gateway

**Problem:** Backend returns 502 error

**Solutions:**
- Check backend is running (PM2 status)
- Verify PORT environment variable
- Check backend logs for errors
- Restart backend service

#### 7. Environment Variables Not Loading

**Problem:** App can't read environment variables

**Solutions:**
- For Vite: Variables must start with `VITE_`
- Restart dev server after changing .env
- Check .env file location
- Verify environment variables are set in hosting platform

---

## Monitoring and Maintenance

### Monitoring

1. **Backend Monitoring**
   - Use PM2 monitoring: `pm2 monit`
   - Set up error logging (Sentry, LogRocket)
   - Monitor API response times

2. **Database Monitoring**
   - MongoDB Atlas provides built-in monitoring
   - Set up alerts for high CPU/memory usage
   - Monitor connection pool

3. **Frontend Monitoring**
   - Use Vercel/Netlify analytics
   - Set up error tracking (Sentry)
   - Monitor Core Web Vitals

### Maintenance Tasks

- **Daily:** Check logs for errors
- **Weekly:** Review performance metrics
- **Monthly:** Update dependencies
- **Quarterly:** Backup database
- **Yearly:** Renew SSL certificates (auto with Let's Encrypt)

---

## Scaling Considerations

### When to Scale

- Response times > 1 second
- CPU usage consistently > 80%
- Memory usage > 80%
- Database connections maxed out

### Scaling Options

1. **Vertical Scaling**
   - Upgrade server resources (RAM, CPU)
   - Increase MongoDB tier

2. **Horizontal Scaling**
   - Add more backend instances
   - Use load balancer
   - Set up Redis for session storage

3. **Database Scaling**
   - Enable MongoDB sharding
   - Add read replicas
   - Implement caching

---

## Cost Estimates

### Free Tier (Suitable for MVP/Testing)

- **Frontend:** Vercel/Netlify (Free)
- **Backend:** Render/Railway (Free tier with limitations)
- **Database:** MongoDB Atlas M0 (Free, 512MB)
- **Total:** $0/month

### Production Tier (Small Business)

- **Frontend:** Vercel Pro ($20/month) or Netlify Pro ($19/month)
- **Backend:** Render Standard ($7/month) or Railway ($5/month)
- **Database:** MongoDB Atlas M10 ($57/month)
- **Total:** ~$85/month

### Enterprise Tier (High Traffic)

- **Frontend:** Vercel Enterprise ($150+/month)
- **Backend:** Multiple instances (~$100/month)
- **Database:** MongoDB Atlas M30+ ($300+/month)
- **CDN:** CloudFlare Pro ($20/month)
- **Total:** $570+/month

---

## Additional Resources

### Documentation
- [MongoDB Atlas Docs](https://docs.atlas.mongodb.com/)
- [Express.js Guide](https://expressjs.com/en/guide/routing.html)
- [React Deployment](https://reactjs.org/docs/deployment.html)
- [Vite Deployment](https://vitejs.dev/guide/static-deploy.html)

### Tools
- [PM2 Process Manager](https://pm2.keymetrics.io/)
- [Let's Encrypt SSL](https://letsencrypt.org/)
- [Nginx Documentation](https://nginx.org/en/docs/)

### Support
- GitHub Issues: Report bugs and request features
- Discord/Slack: Join community for help
- Email: support@yourdomain.com

---

## Security Best Practices

1. **Environment Variables**
   - Never commit .env files
   - Use strong JWT secrets (32+ characters)
   - Rotate secrets regularly

2. **Database Security**
   - Use strong passwords
   - Restrict network access
   - Enable MongoDB audit logging

3. **API Security**
   - Enable rate limiting
   - Use HTTPS only
   - Implement request validation
   - Keep dependencies updated

4. **Authentication**
   - Use bcrypt for passwords
   - Implement token expiration
   - Add 2FA (optional)

---

## Next Steps

After successful deployment:

1. **Set Up CI/CD**
   - Configure GitHub Actions
   - Automate testing
   - Auto-deploy on push

2. **Add Monitoring**
   - Set up error tracking
   - Configure uptime monitoring
   - Add performance monitoring

3. **Implement Backups**
   - Schedule database backups
   - Store in cloud storage
   - Test restore procedures

4. **Custom Domain**
   - Purchase domain name
   - Configure DNS records
   - Set up SSL certificate

5. **Marketing**
   - Add SEO metadata
   - Create sitemap
   - Set up analytics

---

**Congratulations! 🎉 Your Aidora Marketplace is now live!**

For additional help, refer to the [README.md](README.md) or create an issue on GitHub.

---

*Last Updated: December 2024*
*Version: 1.0.0*
