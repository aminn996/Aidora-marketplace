# 📋 Deployment Checklist - Aidora Marketplace

Use this checklist to ensure a smooth deployment of your Aidora marketplace application.

## Pre-Deployment Checklist

### 📦 Prerequisites Setup
- [ ] **MongoDB Atlas Account Created**
  - [ ] Free M0 cluster created
  - [ ] Database user created with password
  - [ ] Network access configured (0.0.0.0/0 for cloud, or specific IPs)
  - [ ] Connection string obtained

- [ ] **Gmail Account Configured**
  - [ ] 2-Factor Authentication enabled
  - [ ] App Password generated (16 characters)
  - [ ] Test email sent successfully

- [ ] **Google OAuth Setup**
  - [ ] Google Cloud project created
  - [ ] Google+ API enabled
  - [ ] OAuth 2.0 credentials created
  - [ ] Authorized JavaScript origins added
  - [ ] Authorized redirect URIs added
  - [ ] Consent screen configured

- [ ] **Facebook OAuth Setup**
  - [ ] Facebook Developer account created
  - [ ] Facebook app created
  - [ ] Facebook Login product added
  - [ ] Valid OAuth redirect URIs configured
  - [ ] App made public (if needed)

### 🔐 Environment Variables Prepared
- [ ] **Backend Environment Variables**
  - [ ] `MONGO_URI` - MongoDB connection string
  - [ ] `JWT_SECRET` - 32+ character random string
  - [ ] `PORT` - 5000 (or your preferred port)
  - [ ] `NODE_ENV` - set to "production"
  - [ ] `BACKEND_URL` - Your backend domain
  - [ ] `FRONTEND_URL` - Your frontend domain
  - [ ] `EMAIL_USER` - Gmail address
  - [ ] `EMAIL_PASSWORD` - Gmail App Password
  - [ ] `GOOGLE_CLIENT_ID` - From Google Console
  - [ ] `GOOGLE_CLIENT_SECRET` - From Google Console
  - [ ] `FACEBOOK_APP_ID` - From Facebook Developers
  - [ ] `FACEBOOK_APP_SECRET` - From Facebook Developers

- [ ] **Frontend Environment Variables**
  - [ ] `VITE_API_URL` - Backend API URL + /api
  - [ ] `VITE_GOOGLE_CLIENT_ID` - Same as backend
  - [ ] `VITE_FACEBOOK_APP_ID` - Same as backend

### 💻 Code Preparation
- [ ] All code committed to Git repository
- [ ] `.env` files added to `.gitignore`
- [ ] Dependencies up to date (`npm update`)
- [ ] No sensitive data in code
- [ ] README.md updated
- [ ] Documentation reviewed

---

## Deployment Steps

### Option 1: Vercel + Render

#### Backend (Render)
- [ ] Signed up at render.com
- [ ] Connected GitHub account
- [ ] Created new Web Service
- [ ] Selected repository
- [ ] Configured build settings:
  - [ ] Root Directory: `root/backend`
  - [ ] Build Command: `npm install`
  - [ ] Start Command: `npm start`
- [ ] Added all environment variables
- [ ] Clicked "Create Web Service"
- [ ] Deployment successful
- [ ] Backend URL noted: `_________________`

#### Frontend (Vercel)
- [ ] Signed up at vercel.com
- [ ] Imported GitHub repository
- [ ] Configured build settings:
  - [ ] Framework Preset: Vite
  - [ ] Root Directory: `root/frontend`
  - [ ] Build Command: `npm run build`
  - [ ] Output Directory: `dist`
- [ ] Added environment variables
- [ ] Deployed successfully
- [ ] Frontend URL noted: `_________________`

#### Post-Deployment (Vercel + Render)
- [ ] Updated `FRONTEND_URL` in Render backend settings
- [ ] Redeployed backend on Render
- [ ] Updated OAuth redirect URIs in Google Console
- [ ] Updated OAuth redirect URIs in Facebook Console

### Option 2: Netlify + Railway

#### Backend (Railway)
- [ ] Signed up at railway.app
- [ ] Created new project from GitHub
- [ ] Selected repository
- [ ] Set root directory: `root/backend`
- [ ] Added all environment variables
- [ ] Generated domain
- [ ] Deployment successful
- [ ] Backend URL noted: `_________________`

#### Frontend (Netlify)
- [ ] Signed up at netlify.com
- [ ] Imported existing project from GitHub
- [ ] Configured build settings:
  - [ ] Base directory: `root/frontend`
  - [ ] Build command: `npm run build`
  - [ ] Publish directory: `root/frontend/dist`
- [ ] Added environment variables
- [ ] Deployed successfully
- [ ] Frontend URL noted: `_________________`

#### Post-Deployment (Netlify + Railway)
- [ ] Updated `FRONTEND_URL` in Railway backend settings
- [ ] Redeployed backend on Railway
- [ ] Updated OAuth redirect URIs

### Option 3: Docker

- [ ] Docker and Docker Compose installed
- [ ] Created `.env` file in root directory
- [ ] Built Docker images: `docker-compose build`
- [ ] Started containers: `docker-compose up -d`
- [ ] Verified containers running: `docker-compose ps`
- [ ] Checked logs: `docker-compose logs`
- [ ] Tested application locally
- [ ] Pushed images to container registry (if deploying to cloud)
- [ ] Deployed to cloud platform (AWS/GCP/Azure)

### Option 4: VPS (DigitalOcean/AWS EC2)

#### Server Setup
- [ ] Created VPS instance (Ubuntu 22.04)
- [ ] SSH access configured
- [ ] System updated: `apt update && apt upgrade`
- [ ] Node.js 18+ installed
- [ ] PM2 installed globally
- [ ] Nginx installed
- [ ] Certbot installed (for SSL)

#### Application Deployment
- [ ] Repository cloned to `/var/www`
- [ ] Backend dependencies installed
- [ ] Backend `.env` file configured
- [ ] Backend started with PM2: `pm2 start server.js`
- [ ] PM2 startup configured: `pm2 startup`
- [ ] Frontend dependencies installed
- [ ] Frontend `.env` file configured
- [ ] Frontend built: `npm run build`

#### Nginx Configuration
- [ ] Nginx config file created
- [ ] Backend proxy configured
- [ ] Frontend static serving configured
- [ ] Site enabled: `ln -s /etc/nginx/sites-available/aidora /etc/nginx/sites-enabled/`
- [ ] Nginx tested: `nginx -t`
- [ ] Nginx restarted: `systemctl restart nginx`

#### SSL Setup
- [ ] Domain DNS configured (A record pointing to server IP)
- [ ] SSL certificate obtained: `certbot --nginx -d yourdomain.com`
- [ ] Auto-renewal tested: `certbot renew --dry-run`

#### Security
- [ ] Firewall configured: `ufw allow 22,80,443/tcp`
- [ ] Firewall enabled: `ufw enable`
- [ ] SSH key authentication enabled
- [ ] Password authentication disabled (optional)

---

## Post-Deployment Verification

### 🧪 Functional Testing
- [ ] **Backend Health Check**
  ```bash
  curl https://your-backend-url/api/health
  # Expected: {"status":"ok"}
  ```

- [ ] **Frontend Loads**
  - [ ] Homepage loads successfully
  - [ ] No console errors
  - [ ] All assets load correctly
  - [ ] Page is responsive on mobile

- [ ] **Authentication Flow**
  - [ ] Email/password registration works
  - [ ] Email/password login works
  - [ ] Google OAuth login works
  - [ ] Facebook OAuth login works
  - [ ] Logout works
  - [ ] Protected routes are secure

- [ ] **Service Browsing**
  - [ ] Services page loads
  - [ ] Can view service details
  - [ ] Search functionality works
  - [ ] Filter by category works

- [ ] **Booking System**
  - [ ] Can create a booking
  - [ ] Time slots display correctly
  - [ ] Provider receives email notification
  - [ ] Customer receives confirmation email
  - [ ] Booking status updates work
  - [ ] Can view booking history

- [ ] **Provider Dashboard**
  - [ ] Can view all bookings
  - [ ] Can accept/decline bookings
  - [ ] Email notifications sent on status change
  - [ ] Can create/edit services

- [ ] **Admin Panel** (if applicable)
  - [ ] Admin can login
  - [ ] Can view all users
  - [ ] Can manage services
  - [ ] Can view analytics

### 🔒 Security Verification
- [ ] HTTPS enabled (SSL certificate valid)
- [ ] All API calls use HTTPS
- [ ] CORS configured correctly
- [ ] Rate limiting is active
- [ ] Environment variables are secure (not exposed)
- [ ] No sensitive data in client-side code
- [ ] JWT tokens expire properly
- [ ] Passwords are hashed (bcrypt)
- [ ] XSS protection enabled
- [ ] Security headers configured (helmet)

### ⚡ Performance Check
- [ ] Frontend loads in < 3 seconds
- [ ] API responses < 500ms average
- [ ] Images optimized
- [ ] Static assets cached properly
- [ ] Gzip compression enabled
- [ ] No memory leaks in backend
- [ ] Database queries optimized

### 📧 Email Verification
- [ ] New booking email sent to provider
- [ ] Booking confirmation email sent to customer
- [ ] Booking declined email sent to customer
- [ ] Emails have correct formatting
- [ ] Emails contain all required information
- [ ] Links in emails work correctly

### 🌐 Cross-Browser Testing
- [ ] Chrome/Chromium
- [ ] Firefox
- [ ] Safari
- [ ] Edge
- [ ] Mobile browsers (iOS Safari, Chrome Mobile)

### 📱 Mobile Responsiveness
- [ ] Homepage responsive on mobile
- [ ] Login/signup forms work on mobile
- [ ] Service browsing works on mobile
- [ ] Booking flow works on mobile
- [ ] Dashboard accessible on mobile

---

## Monitoring Setup

### 📊 Application Monitoring
- [ ] Error tracking set up (Sentry, LogRocket)
- [ ] Performance monitoring configured
- [ ] Uptime monitoring enabled (UptimeRobot, Pingdom)
- [ ] Log aggregation configured
- [ ] Alerts set up for:
  - [ ] Server downtime
  - [ ] High error rates
  - [ ] Slow response times
  - [ ] Database connection failures

### 📈 Analytics
- [ ] Google Analytics installed (optional)
- [ ] Custom event tracking configured
- [ ] Conversion tracking set up
- [ ] User behavior tracking enabled

---

## Maintenance Tasks

### 🗓️ Regular Tasks
- [ ] **Daily**: Check error logs
- [ ] **Daily**: Monitor uptime
- [ ] **Weekly**: Review performance metrics
- [ ] **Weekly**: Check database size
- [ ] **Monthly**: Update dependencies
- [ ] **Monthly**: Review security alerts
- [ ] **Quarterly**: Database backup and restore test
- [ ] **Yearly**: Renew domain and certificates (if manual)

### 🔄 Backup Strategy
- [ ] Database backup configured
- [ ] Backup schedule set (daily recommended)
- [ ] Backup storage location configured
- [ ] Backup restoration tested
- [ ] Backup retention policy defined

---

## Documentation

### 📚 Documentation Complete
- [ ] Deployment guide updated
- [ ] README.md updated with live URLs
- [ ] API documentation current
- [ ] Environment variables documented
- [ ] Troubleshooting guide updated
- [ ] Contributing guidelines reviewed

### 👥 Team Knowledge
- [ ] Team trained on deployment process
- [ ] Access credentials shared securely
- [ ] On-call rotation established (if applicable)
- [ ] Incident response plan documented

---

## Optional Enhancements

### 🚀 Advanced Features
- [ ] CDN configured (CloudFlare, AWS CloudFront)
- [ ] CI/CD pipeline set up (GitHub Actions)
- [ ] Staging environment created
- [ ] Load balancer configured (for multiple instances)
- [ ] Redis cache implemented
- [ ] Database read replicas configured
- [ ] Automated testing in CI/CD
- [ ] Blue-green deployment strategy

### 🎨 Customization
- [ ] Custom domain configured
- [ ] Custom email domain (no-reply@yourdomain.com)
- [ ] Branded error pages
- [ ] Custom 404 page
- [ ] Favicon and app icons
- [ ] SEO optimization completed
- [ ] OpenGraph tags added
- [ ] Sitemap generated

---

## Final Sign-Off

### ✅ Deployment Complete
- [ ] All checklist items completed
- [ ] Stakeholders notified
- [ ] Documentation handed off
- [ ] Support team briefed
- [ ] Monitoring dashboards bookmarked
- [ ] Emergency contacts documented

### 📝 Deployment Notes
**Deployed by:** `_________________`
**Date:** `_________________`
**Backend URL:** `_________________`
**Frontend URL:** `_________________`
**Version:** `_________________`

**Special Notes:**
```
_______________________________________________________
_______________________________________________________
_______________________________________________________
```

---

## 🎉 Congratulations!

Your Aidora Marketplace is now live and ready to serve users!

### Need Help?
- 📖 [Full Deployment Guide](DEPLOYMENT_GUIDE.md)
- 🚀 [Quick Deploy Guide](QUICK_DEPLOY.md)
- 💬 [GitHub Issues](https://github.com/your-repo/issues)
- 📧 Support: support@yourdomain.com

---

*Last Updated: December 2024*
*Version: 1.0.0*
