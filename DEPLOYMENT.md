# Cloud Deployment Guide - Nakshita Jewellers ERP

## 🌟 Deploy with GitHub Student Developer Pack

### Option 1: DigitalOcean App Platform (Recommended)

#### Prerequisites
1. GitHub account with your project repository
2. DigitalOcean account (free with Student Pack)

#### Step 1: Push to GitHub
```bash
# Initialize git repository (if not done)
git init
git add .
git commit -m "Initial commit - Nakshita Jewellers ERP"

# Create repository on GitHub and push
git remote add origin https://github.com/YOUR_USERNAME/nakshita-jewellers-erp.git
git branch -M main
git push -u origin main
```

#### Step 2: Deploy on DigitalOcean
1. **Sign up**: Go to [DigitalOcean](https://www.digitalocean.com/)
   - Use GitHub Student Pack to get $200 credit
   
2. **Create App**: 
   - Go to Apps → Create App
   - Connect your GitHub repository
   - Select `nakshita-jewellers-erp` repository

3. **Configure Services**:
   - **Backend Service**:
     - Source Directory: `/backend`
     - Build Command: `npm install`
     - Run Command: `npm start`
     - Environment Variables:
       ```
       NODE_ENV=production
       JWT_SECRET=your_secure_jwt_secret
       DATABASE_URL=${db.DATABASE_URL}
       ```
   
   - **Frontend Service**:
     - Source Directory: `/frontend`
     - Build Command: `npm install && npm run build`
     - Run Command: `npm run preview`
     - Environment Variables:
       ```
       VITE_API_URL=${backend.PUBLIC_URL}
       ```

4. **Add Database**:
   - Add PostgreSQL database
   - Size: Development (free tier)
   - Version: 14

5. **Deploy**: Click "Create Resources"

#### Step 3: Initialize Database
After deployment, run the database schema:
```bash
# Connect to your deployed database and run:
psql $DATABASE_URL -f database/schema.sql
```

### Option 2: Railway (Alternative)

1. **Connect GitHub**: Sign up at [Railway](https://railway.app/)
2. **Deploy**: 
   - New Project → Deploy from GitHub
   - Select your repository
   - Railway will auto-detect Node.js

3. **Add Database**: Add PostgreSQL service
4. **Set Environment Variables** in Railway dashboard

### Option 3: Heroku (Traditional)

1. **Install Heroku CLI**
2. **Login**: `heroku login`
3. **Create Apps**:
   ```bash
   heroku create nakshita-erp-backend
   heroku create nakshita-erp-frontend
   ```
4. **Add Database**: `heroku addons:create heroku-postgresql:hobby-dev`
5. **Deploy**: `git push heroku main`

## 🚀 Quick Deploy Script

Use this for DigitalOcean:

```bash
# 1. Install doctl (DigitalOcean CLI)
# Download from: https://github.com/digitalocean/doctl/releases

# 2. Authenticate
doctl auth init

# 3. Deploy app
doctl apps create .do/app.yaml

# 4. Check deployment status
doctl apps list
```

## 🔧 Environment Configuration

### Production Environment Variables
```env
NODE_ENV=production
PORT=5000
DATABASE_URL=postgresql://username:password@host:port/database
JWT_SECRET=your_super_secure_jwt_secret_key
FRONTEND_URL=https://your-frontend-url.com
```

### Frontend Environment Variables
```env
VITE_API_URL=https://your-backend-url.com
```

## 📱 Access Your Deployed App

After deployment, you'll get URLs like:
- **Frontend**: `https://nakshita-erp-abc123.ondigitalocean.app`
- **Backend API**: `https://nakshita-erp-backend-def456.ondigitalocean.app`

## 🔐 Default Login (Production)
- Username: `admin`
- Password: `admin123`
- Role: `Admin`

**⚠️ Important**: Change the default password after first login!

## 💰 Cost Estimation

### DigitalOcean (with $200 credit):
- Basic App: $5-10/month
- Database: $15/month
- **Total**: ~$25/month (covered by credit for 8+ months)

### Railway (with $5 credit):
- Hobby Plan: $5/month
- Database included
- **Total**: $5/month (1 month free)

### Heroku (with $13 credit):
- Dyno: $7/month
- Database: $9/month
- **Total**: $16/month

## 🌐 Custom Domain (Optional)

Add your custom domain in the platform's dashboard:
1. Point DNS to provided CNAME
2. Enable SSL (automatic)
3. Update environment variables

## 📊 Monitoring & Scaling

All platforms provide:
- Application logs
- Performance metrics
- Auto-scaling options
- Backup management

## 🔄 Continuous Deployment

Set up automatic deployment:
1. Connect GitHub repository
2. Enable auto-deploy on push to `main` branch
3. Set up staging environments for testing

Your ERP system will be accessible 24/7 from anywhere in the world! 🌍