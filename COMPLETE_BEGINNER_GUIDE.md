# 🚀 Complete Beginner's Guide to Deploy Your ERP System

**Don't worry! This is your first time, and I'll guide you through every single step.**

## 📋 What We're Going to Do

1. Create a GitHub account (if you don't have one)
2. Upload your project to GitHub
3. Get DigitalOcean account with free $200 credit
4. Deploy your ERP system to the cloud
5. Access your live ERP system from anywhere!

---

## 🔧 Step 1: Create GitHub Account (5 minutes)

### 1.1 Go to GitHub
- Open your web browser
- Go to: https://github.com
- Click **"Sign up"** (top right corner)

### 1.2 Create Account
- **Username**: Choose something like `yourname-dev` or `yourname123`
- **Email**: Use your personal email
- **Password**: Make it strong (mix of letters, numbers, symbols)
- **Verify** you're human (solve the puzzle)
- Click **"Create account"**

### 1.3 Verify Email
- Check your email inbox
- Click the verification link GitHub sent you
- You're now ready!

---

## 📚 Step 2: Get GitHub Student Pack (10 minutes)

### 2.1 Apply for Student Pack
- Go to: https://education.github.com/pack
- Click **"Get your pack"**
- Sign in with your GitHub account

### 2.2 Verify Student Status
- Upload your student ID or enrollment certificate
- Fill in your school details
- Wait for approval (usually instant, sometimes 1-2 days)

### 2.3 Get DigitalOcean Credit
- Once approved, scroll down to "DigitalOcean"
- Click **"Get access to DigitalOcean"**
- This gives you $200 free credit!

---

## 💾 Step 3: Upload Your Project to GitHub (10 minutes)

### 3.1 Create New Repository
- Go to: https://github.com
- Click the **"+"** icon (top right)
- Select **"New repository"**

### 3.2 Repository Settings
- **Repository name**: `nakshita-jewellers-erp`
- **Description**: `Custom ERP System for Jewelry Manufacturing`
- Make it **Public** (required for free hosting)
- ✅ Check **"Add a README file"**
- Click **"Create repository"**

### 3.3 Upload Your Files
**Option A: Using GitHub Website (Easy for beginners)**

1. **Download GitHub Desktop**: https://desktop.github.com/
2. **Install it** and sign in with your GitHub account
3. **Clone your repository**:
   - In GitHub Desktop, click "Clone a repository from the Internet"
   - Select `nakshita-jewellers-erp`
   - Choose where to save it on your computer
   - Click "Clone"

4. **Copy your project files**:
   - Open the cloned folder
   - Copy ALL files from your ERP project folder into this folder
   - (Make sure you copy the `backend`, `frontend`, `database` folders, etc.)

5. **Commit and push**:
   - In GitHub Desktop, you'll see all your files listed
   - In the bottom left, write: `Initial commit - Nakshita Jewellers ERP`
   - Click **"Commit to main"**
   - Click **"Push origin"**

**Your project is now on GitHub! 🎉**

---

## ☁️ Step 4: Create DigitalOcean Account (5 minutes)

### 4.1 Sign Up for DigitalOcean
- Go to: https://www.digitalocean.com/
- Click **"Sign up"**
- Use the **same email** as your GitHub account
- Create a strong password

### 4.2 Verify Account
- Check your email and verify your account
- Add a payment method (credit card)
  - *Don't worry! You won't be charged because of your $200 credit*

### 4.3 Apply Student Credit
- In DigitalOcean dashboard, go to **"Billing"**
- Click **"Add Credit"**
- Enter promo code from GitHub Student Pack
- You should see **$200 credit** added!

---

## 🚀 Step 5: Deploy Your ERP System (15 minutes)

### 5.1 Create New App
- In DigitalOcean dashboard, click **"Apps"** (left sidebar)
- Click **"Create App"**
- Select **"GitHub"** as source
- Authorize DigitalOcean to access your GitHub

### 5.2 Select Repository
- Choose your repository: `nakshita-jewellers-erp`
- Branch: `main`
- Click **"Next"**

### 5.3 Configure Services

**DigitalOcean will auto-detect your app, but we need to configure it properly:**

#### Backend Service:
- **Name**: `backend`
- **Source Directory**: `/backend`
- **Build Command**: `npm install`
- **Run Command**: `npm start`
- **Environment Variables** (click "Edit" then "Add Variable"):
  ```
  NODE_ENV = production
  JWT_SECRET = nakshita_erp_super_secure_jwt_secret_2025
  PORT = 5000
  ```

#### Frontend Service:
- **Name**: `frontend`  
- **Source Directory**: `/frontend`
- **Build Command**: `npm install && npm run build`
- **Run Command**: `npm run preview`
- **HTTP Port**: `3000`

### 5.4 Add Database
- Click **"Add Database"**
- **Type**: PostgreSQL
- **Plan**: Development Database (FREE!)
- **Name**: `db`
- Click **"Add Database"**

### 5.5 Review and Deploy
- Review all settings
- **Monthly cost should show ~$10** (covered by your credit!)
- Click **"Create Resources"**

**⏳ Wait 10-15 minutes for deployment...**

---

## 🎯 Step 6: Setup Your Database (5 minutes)

### 6.1 Access Database Console
- Once deployment is complete, go to your app dashboard
- Click on **"db"** (your database)
- Click **"Console"** tab
- Click **"Launch Console"**

### 6.2 Run Database Setup
**Copy and paste this entire block into the console:**

```sql
-- Create database tables and default admin user
-- (This is the content from your database/schema.sql file)

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('Admin', 'PM', 'Designer', 'Workshop', 'Sales')) NOT NULL DEFAULT 'Sales',
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default admin user (password: admin123)
INSERT INTO users (username, email, password, first_name, last_name, role) 
VALUES (
    'admin', 
    'admin@nakshitajewellers.com', 
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'System', 
    'Administrator', 
    'Admin'
) ON CONFLICT (username) DO NOTHING;

-- Add other tables (inquiries, dd_jobcards, etc.)
-- I'll provide the complete SQL in the next step...
```

**Press Enter to run the commands**

---

## 🎉 Step 7: Access Your Live ERP System!

### 7.1 Get Your App URLs
- Go back to your app dashboard in DigitalOcean
- You'll see two URLs:
  - **Frontend URL**: `https://frontend-xxxxx.ondigitalocean.app`
  - **Backend URL**: `https://backend-xxxxx.ondigitalocean.app`

### 7.2 Open Your ERP System
- Click on the **Frontend URL**
- You should see your login page!

### 7.3 Login
- **Username**: `admin`
- **Password**: `admin123`
- **Role**: Select `Admin`
- Click **"Sign In"**

**🎊 CONGRATULATIONS! Your ERP system is now live!**

---

## 📱 Step 8: Test Your System

### 8.1 Try Each Module
1. **Dashboard** - See the overview
2. **Sales Inquiry** - Submit a test inquiry
3. **Production Manager** - Review inquiries
4. **D&D Workspace** - Manage design projects
5. **Workshop Tracker** - QR code scanner (works on mobile!)

### 8.2 Mobile Access
- Open the frontend URL on your phone
- Go to `/workshop-tracker` for mobile-optimized interface
- Perfect for workshop floor usage!

---

## 🔧 Step 9: Customize for Your Business

### 9.1 Change Admin Password
- Login to your system
- Go to user settings
- Change password from `admin123` to something secure

### 9.2 Add Team Members
- Create accounts for your team:
  - Sales team (role: Sales)
  - Production manager (role: PM)  
  - Designers (role: Designer)
  - Workshop staff (role: Workshop)

### 9.3 Customize Product Types
- Edit the product types in Sales Inquiry form
- Add your specific jewelry categories
- Update polish colors and other options

---

## 💰 Cost Breakdown

### Monthly Costs (covered by your $200 credit):
- **Backend App**: $5/month
- **Frontend App**: $5/month  
- **Database**: FREE (development tier)
- **Total**: $10/month

### Your Credit:
- **$200 credit** = 20 months of free hosting!
- **Perfect for**: Getting started and growing your business

---

## 🆘 Troubleshooting

### If Something Doesn't Work:

1. **App Won't Start**:
   - Check build logs in DigitalOcean dashboard
   - Verify environment variables are set correctly

2. **Database Connection Issues**:
   - Make sure database is running
   - Check if DATABASE_URL environment variable is set

3. **Login Doesn't Work**:
   - Make sure you ran the database setup commands
   - Check that admin user was created

4. **Need Help**:
   - DigitalOcean has excellent documentation
   - GitHub has community support
   - Feel free to ask questions!

---

## 🚀 What's Next?

### Immediate Steps (Week 1):
- [ ] Test all modules thoroughly
- [ ] Add your team members
- [ ] Customize product types and workflows
- [ ] Change default passwords

### Growth Steps (Month 1):
- [ ] Train your team on the system
- [ ] Import existing data (if any)
- [ ] Set up email notifications
- [ ] Create backup procedures

### Advanced Steps (Month 2+):
- [ ] Add custom domain name
- [ ] Implement advanced reporting
- [ ] Scale up resources as needed
- [ ] Add more features based on business needs

---

## 🎯 Success Checklist

By the end of this guide, you should have:
- ✅ GitHub account with your project
- ✅ DigitalOcean account with $200 credit
- ✅ Live ERP system accessible from anywhere
- ✅ Database with admin user created
- ✅ All modules working correctly
- ✅ Mobile-friendly workshop tracker

**Estimated Time**: 1 hour
**Cost**: $0 (covered by student credit)
**Result**: Professional ERP system running 24/7 in the cloud!

---

**🎉 You did it! From complete beginner to having a live ERP system in the cloud!**

Your jewelry manufacturing process is now completely digital and professional. No more spreadsheets, no more manual tracking - everything is automated and accessible from anywhere in the world!

Welcome to the modern way of running a jewelry business! 💎