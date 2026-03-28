# 🏗️ Aidora Marketplace - Deployment Architecture

This document provides visual representations of different deployment architectures for the Aidora marketplace.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER BROWSER                             │
│                    (React SPA + Vite)                            │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           │ HTTPS
                           │
┌──────────────────────────▼──────────────────────────────────────┐
│                      FRONTEND (React)                            │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  - Login/Register Pages                                │    │
│  │  - Service Browser                                      │    │
│  │  - Booking System                                       │    │
│  │  - Provider Dashboard                                   │    │
│  │  - Customer Dashboard                                   │    │
│  │  - Admin Panel                                          │    │
│  └────────────────────────────────────────────────────────┘    │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           │ REST API
                           │
┌──────────────────────────▼──────────────────────────────────────┐
│                    BACKEND (Express.js)                          │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  Authentication Layer                                   │    │
│  │  ├─ JWT Token Management                                │    │
│  │  ├─ Google OAuth                                        │    │
│  │  ├─ Facebook OAuth                                      │    │
│  │  └─ Email/Password                                      │    │
│  ├────────────────────────────────────────────────────────┤    │
│  │  API Routes                                             │    │
│  │  ├─ /api/auth (Authentication)                          │    │
│  │  ├─ /api/services (Services CRUD)                       │    │
│  │  ├─ /api/bookings (Booking Management)                  │    │
│  │  ├─ /api/payments (Payment Processing)                  │    │
│  │  ├─ /api/users (User Management)                        │    │
│  │  └─ /api/admin (Admin Operations)                       │    │
│  ├────────────────────────────────────────────────────────┤    │
│  │  Business Logic                                         │    │
│  │  ├─ Role-Based Access Control                          │    │
│  │  ├─ Email Notifications                                │    │
│  │  ├─ Booking Validation                                 │    │
│  │  └─ Payment Calculations                               │    │
│  └────────────────────────────────────────────────────────┘    │
└──────────────────┬─────────────────────┬────────────────────────┘
                   │                     │
                   │                     │
        ┌──────────▼──────────┐  ┌──────▼─────────┐
        │   MongoDB Atlas     │  │  Gmail SMTP    │
        │   (Database)        │  │  (Email)       │
        │                     │  │                │
        │  ┌───────────────┐ │  │  Nodemailer   │
        │  │ Users         │ │  │  ├─ New Booking│
        │  │ Services      │ │  │  ├─ Confirmed  │
        │  │ Bookings      │ │  │  └─ Declined   │
        │  │ Reviews       │ │  │                │
        │  └───────────────┘ │  └────────────────┘
        └─────────────────────┘
```

---

## Deployment Architecture Options

### Option 1: Vercel + Render (Recommended for Beginners)

```
┌──────────────────────────────────────────────────────────────┐
│                      INTERNET                                 │
└───────┬────────────────────────────────────────┬─────────────┘
        │                                        │
        │                                        │
┌───────▼────────────┐              ┌───────────▼──────────────┐
│   VERCEL CDN       │              │    RENDER.COM            │
│   (Frontend)       │              │    (Backend)             │
│                    │              │                          │
│  ┌──────────────┐  │              │  ┌────────────────────┐ │
│  │ React Build  │  │◄─────API─────┤  │ Express.js Server │ │
│  │ (Static)     │  │    Calls     │  │ (Node.js)         │ │
│  └──────────────┘  │              │  └────────────────────┘ │
│                    │              │                          │
│  Global CDN        │              │  Auto-deploy from Git   │
│  Automatic SSL     │              │  Auto-scaling          │
│  $0-20/month       │              │  $0-85/month           │
└────────────────────┘              └──────────┬───────────────┘
                                               │
                                               │
                                    ┌──────────▼──────────────┐
                                    │   MongoDB Atlas         │
                                    │   (Database)            │
                                    │   $0-57/month           │
                                    └─────────────────────────┘
```

**Total Cost:** $0-162/month  
**Setup Time:** 15 minutes  
**Difficulty:** ⭐ (Very Easy)

---

### Option 2: Docker Compose (Single Server)

```
┌─────────────────────────────────────────────────────────────┐
│                    SINGLE VPS SERVER                         │
│                  (DigitalOcean, AWS EC2)                     │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                  NGINX (Port 80/443)                   │ │
│  │              (Reverse Proxy + SSL)                     │ │
│  └────┬──────────────────────────────────────────┬────────┘ │
│       │                                          │           │
│  ┌────▼─────────────────┐         ┌─────────────▼────────┐ │
│  │  Frontend Container  │         │  Backend Container   │ │
│  │  (Nginx + React)     │         │  (Node.js + Express) │ │
│  │  Port: 3000          │         │  Port: 5000          │ │
│  └──────────────────────┘         └──────────┬───────────┘ │
│                                               │              │
└───────────────────────────────────────────────┼──────────────┘
                                                │
                                     ┌──────────▼──────────────┐
                                     │   MongoDB Atlas         │
                                     │   (Managed Database)    │
                                     └─────────────────────────┘
```

**Total Cost:** $12-24/month (VPS) + $57/month (DB) = $69-81/month  
**Setup Time:** 25 minutes  
**Difficulty:** ⭐⭐⭐ (Moderate)

---

### Option 3: VPS with PM2 (Traditional)

```
┌─────────────────────────────────────────────────────────────┐
│              VPS SERVER (Ubuntu 22.04)                       │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              NGINX (Port 80/443)                       │ │
│  │    - Reverse proxy for backend                         │ │
│  │    - Static file serving for frontend                  │ │
│  │    - SSL/TLS termination (Let's Encrypt)               │ │
│  └────┬──────────────────────────────────────────┬────────┘ │
│       │                                          │           │
│  ┌────▼─────────────────┐         ┌─────────────▼────────┐ │
│  │  Frontend (Dist)     │         │  Backend (PM2)       │ │
│  │  /var/www/.../dist   │         │  Node.js Process     │ │
│  │  (Built files)       │         │  Port: 5000          │ │
│  └──────────────────────┘         │  Auto-restart        │ │
│                                    └──────────┬───────────┘ │
└───────────────────────────────────────────────┼──────────────┘
                                                │
                                     ┌──────────▼──────────────┐
                                     │   MongoDB Atlas         │
                                     │   (Managed Database)    │
                                     └─────────────────────────┘
```

**Total Cost:** $12-24/month (VPS) + $57/month (DB) = $69-81/month  
**Setup Time:** 35 minutes  
**Difficulty:** ⭐⭐⭐⭐ (Technical)

---

### Option 4: AWS/GCP Production (Enterprise)

```
┌────────────────────────────────────────────────────────────────┐
│                       CLOUD LOAD BALANCER                       │
│                         (AWS ALB/GCP LB)                        │
└────┬──────────────────────────────────────────────────┬────────┘
     │                                                   │
     │ HTTPS                                             │ HTTPS
     │                                                   │
┌────▼─────────────────────┐              ┌─────────────▼───────────┐
│   Frontend (S3/GCS)      │              │  Backend Auto-Scaling   │
│   + CloudFront CDN       │              │  (ECS/Cloud Run)        │
│                          │              │                         │
│  Static React Build      │◄─────API─────┤  ┌─────┐  ┌─────┐     │
│  Global Distribution     │    Calls     │  │ Pod │  │ Pod │ ... │
│  Cache at Edge           │              │  └─────┘  └─────┘     │
│                          │              │                         │
│  Auto-scaling CDN        │              │  Auto-scaling instances │
└──────────────────────────┘              └─────────┬───────────────┘
                                                    │
                                          ┌─────────▼─────────────┐
                                          │  Managed Database     │
                                          │  (RDS/Cloud SQL)      │
                                          │  Multi-AZ Replica     │
                                          └───────────────────────┘
```

**Total Cost:** $200-500+/month  
**Setup Time:** 60+ minutes  
**Difficulty:** ⭐⭐⭐⭐⭐ (Expert)

---

## Data Flow Diagram

### User Registration/Login Flow

```
┌──────┐                                   ┌─────────┐
│ User │                                   │ Backend │
└───┬──┘                                   └────┬────┘
    │                                           │
    │  1. Enter credentials                     │
    ├──────────────────────────────────────────►│
    │                                           │
    │                               2. Validate │
    │                              credentials  │
    │                                           │
    │                    3. Generate JWT token  │
    │◄──────────────────────────────────────────┤
    │                                           │
    │  4. Store token in localStorage           │
    │  5. Redirect to dashboard                 │
    │                                           │
```

### OAuth Login Flow

```
┌──────┐      ┌─────────┐      ┌────────────┐      ┌──────────┐
│ User │      │ Frontend│      │  Backend   │      │ Google/  │
│      │      │         │      │            │      │ Facebook │
└───┬──┘      └────┬────┘      └─────┬──────┘      └─────┬────┘
    │              │                  │                   │
    │ 1. Click    │                  │                   │
    │ "Sign in"   │                  │                   │
    ├─────────────►                  │                   │
    │              │                  │                   │
    │              │ 2. Redirect to   │                   │
    │              │ OAuth provider   │                   │
    │              ├─────────────────►│                   │
    │              │                  │ 3. Redirect       │
    │              │                  ├──────────────────►│
    │              │                  │                   │
    │              │                  │ 4. User approves  │
    │              │                  │◄──────────────────┤
    │              │                  │                   │
    │              │ 5. Callback with │                   │
    │              │ authorization    │                   │
    │              │◄─────────────────┤                   │
    │              │                  │                   │
    │              │ 6. Exchange for  │                   │
    │              │ access token     │                   │
    │              ├─────────────────►│ 7. Get token     │
    │              │                  ├──────────────────►│
    │              │                  │◄──────────────────┤
    │              │                  │                   │
    │              │ 8. Create/link   │                   │
    │              │ user account     │                   │
    │              │                  │                   │
    │              │ 9. Return JWT    │                   │
    │              │◄─────────────────┤                   │
    │ 10. Login    │                  │                   │
    │ success      │                  │                   │
    ◄──────────────┤                  │                   │
```

### Booking Creation Flow

```
┌──────────┐    ┌─────────┐    ┌─────────┐    ┌──────────┐
│ Customer │    │ Backend │    │ Database│    │  Email   │
└─────┬────┘    └────┬────┘    └────┬────┘    └────┬─────┘
      │              │              │              │
      │ 1. Create    │              │              │
      │ booking      │              │              │
      ├─────────────►│              │              │
      │              │              │              │
      │              │ 2. Validate  │              │
      │              │ & Save       │              │
      │              ├─────────────►│              │
      │              │◄─────────────┤              │
      │              │              │              │
      │              │ 3. Send email│              │
      │              │ to provider  │              │
      │              ├──────────────┼─────────────►│
      │              │              │              │
      │ 4. Return    │              │              │
      │ confirmation │              │              │
      │◄─────────────┤              │              │
      │              │              │              │
```

---

## Security Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    SECURITY LAYERS                           │
└─────────────────────────────────────────────────────────────┘

Layer 1: Network Security
┌───────────────────────────────────────────────────────────┐
│  - HTTPS/SSL (TLS 1.3)                                    │
│  - Firewall Rules (UFW/Security Groups)                   │
│  - Rate Limiting (Express Rate Limit)                     │
│  - DDoS Protection (CloudFlare/AWS Shield)                │
└───────────────────────────────────────────────────────────┘

Layer 2: Application Security
┌───────────────────────────────────────────────────────────┐
│  - Helmet.js (Security Headers)                           │
│  - CORS Configuration                                      │
│  - XSS Protection (xss-clean)                             │
│  - Input Validation (Joi)                                 │
│  - SQL Injection Prevention (Mongoose)                    │
└───────────────────────────────────────────────────────────┘

Layer 3: Authentication & Authorization
┌───────────────────────────────────────────────────────────┐
│  - JWT Token Authentication                               │
│  - OAuth 2.0 (Google, Facebook)                           │
│  - Password Hashing (bcryptjs)                            │
│  - Role-Based Access Control (RBAC)                       │
│  - Session Management                                      │
└───────────────────────────────────────────────────────────┘

Layer 4: Data Security
┌───────────────────────────────────────────────────────────┐
│  - MongoDB Encryption at Rest                             │
│  - TLS for Database Connections                           │
│  - Environment Variables for Secrets                      │
│  - Regular Backups                                         │
└───────────────────────────────────────────────────────────┘
```

---

## Scaling Strategy

### Phase 1: MVP (0-1,000 users)
```
Single Instance
├─ Frontend: Vercel/Netlify
├─ Backend: Render/Railway (Free tier)
└─ Database: MongoDB Atlas M0 (Free)

Cost: $0/month
```

### Phase 2: Growth (1,000-10,000 users)
```
Optimized Setup
├─ Frontend: Vercel Pro + CDN
├─ Backend: Render Standard (1 instance)
└─ Database: MongoDB Atlas M10

Cost: $84/month
```

### Phase 3: Scale (10,000-100,000 users)
```
Load Balanced
├─ Frontend: Vercel Pro + Global CDN
├─ Backend: Multiple instances + Load Balancer
├─ Database: MongoDB Atlas M30 + Read Replicas
└─ Cache: Redis for sessions

Cost: $400/month
```

### Phase 4: Enterprise (100,000+ users)
```
Multi-Region
├─ Frontend: Multi-region CDN
├─ Backend: Auto-scaling clusters (3+ regions)
├─ Database: Sharded MongoDB + Replicas
├─ Cache: Redis Cluster
└─ Queue: RabbitMQ/SQS for async tasks

Cost: $1,000+/month
```

---

## Monitoring Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    MONITORING STACK                          │
└─────────────────────────────────────────────────────────────┘

Application Monitoring
├─ Error Tracking: Sentry
├─ Performance: New Relic / DataDog
├─ Logs: CloudWatch / Stackdriver
└─ Uptime: UptimeRobot / Pingdom

Infrastructure Monitoring
├─ Server Metrics: PM2 / Docker Stats
├─ Database: MongoDB Atlas Monitoring
├─ Network: CloudFlare Analytics
└─ Alerts: PagerDuty / Slack

User Analytics
├─ Page Views: Google Analytics
├─ Events: Mixpanel / Amplitude
├─ Errors: LogRocket (Session Replay)
└─ Performance: Web Vitals
```

---

## Backup Strategy

```
┌─────────────────────────────────────────────────────────────┐
│                    BACKUP ARCHITECTURE                       │
└─────────────────────────────────────────────────────────────┘

Database Backups
├─ Automated Daily Backups (MongoDB Atlas)
├─ Point-in-Time Recovery (Last 7 days)
├─ Manual Snapshots (Before major changes)
└─ Backup Retention: 30 days

Code Backups
├─ Git Repository (GitHub)
├─ Protected Branches
├─ Version Tags
└─ Docker Images in Registry

Configuration Backups
├─ Environment Variables (Encrypted storage)
├─ Infrastructure as Code (Terraform/CloudFormation)
└─ Documentation (This file!)
```

---

## Questions?

For detailed deployment instructions, see:
- [QUICK_DEPLOY.md](QUICK_DEPLOY.md) - Fast 15-minute deployment
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Complete guide
- [PLATFORM_COMPARISON.md](PLATFORM_COMPARISON.md) - Choose platform
- [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) - Verification

---

*Last Updated: December 2024*
*Version: 1.0.0*
