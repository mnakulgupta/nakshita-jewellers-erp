# Nakshita Jewellers ERP & Production Tracking System

A comprehensive full-stack Enterprise Resource Planning (ERP) and live production tracking system designed specifically for jewelry manufacturing and wholesale operations.

## Project Overview

This system eliminates manual spreadsheet-based workflows and provides real-time visibility into the entire operation, from initial sales inquiry to final product dispatch. It enforces a strict workflow where users interact with data exclusively through dedicated web interfaces, with automated ID generation, notifications, and status updates.

## Architecture

- **Frontend**: React.js with Vite, Material-UI components
- **Backend**: Node.js with Express.js REST API
- **Database**: PostgreSQL with Sequelize ORM
- **Authentication**: JWT-based role-based access control
- **Features**: QR code generation, PDF generation, email notifications

## Key Features

### 1. Sales Inquiry Management
- Web form for sales team to input new leads
- Auto-generated unique inquiry IDs (NJI-YY-XXX format)
- Automatic PM notifications
- Status tracking from inquiry to finalization

### 2. Production Manager Control Center
- Dashboard for pending inquiry reviews
- Decision workflow: New Creation vs Repeat Order
- Automated BOM lookup for repeat orders
- Production jobcard generation with QR codes

### 3. Design & Development Workspace
- Project management for D&D teams
- Dye creation and tracking system
- Master dye library (Dye Bank)
- CAD/CAM workflow management

### 4. Workshop Stage Tracker
- Mobile-friendly QR code scanning interface
- Real-time production stage tracking
- Weight and piece count logging
- Quality check recording

### 5. Comprehensive Database Schema
- **Inquiries**: Sales lead tracking
- **D&D Jobcards**: Design project management
- **Dye Bank**: Reusable component library
- **Products**: Finished item catalog
- **BOM**: Bill of materials linking products to dyes
- **Production Jobs**: Live workshop dashboard
- **Stage Logs**: Detailed production history

## User Roles

- **Admin**: System administration and user management
- **PM (Production Manager)**: Inquiry review and production planning
- **Designer**: D&D project management and dye creation
- **Workshop**: Production stage tracking and quality control
- **Sales**: Customer inquiry submission

## Getting Started

### 🌟 Quick Cloud Deployment (Recommended)

**Perfect for office environments and GitHub Student Pack users!**

1. **Follow the Quick Deploy Guide**: See `QUICK_DEPLOY.md` for 20-minute cloud setup
2. **Use GitHub Student Pack**: Get $200 DigitalOcean credit
3. **Access from anywhere**: No local installation needed

### 💻 Local Development Setup

### Prerequisites

- Node.js (v16 or higher)
- PostgreSQL (v12 or higher)
- npm or yarn package manager

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd nakshita-jewellers-erp
   ```

2. **Install dependencies**
   ```bash
   # Install root dependencies
   npm install
   
   # Install backend dependencies
   npm run backend:install
   
   # Install frontend dependencies
   npm run frontend:install
   ```

3. **Database Setup**
   ```bash
   # Create PostgreSQL database
   createdb nakshita_jewellers_erp
   
   # Run database schema
   psql -d nakshita_jewellers_erp -f database/schema.sql
   ```

4. **Environment Configuration**
   ```bash
   # Copy environment template
   cp backend/.env.example backend/.env
   
   # Edit backend/.env with your database credentials and settings
   ```

5. **Start Development Servers**
   ```bash
   # Start both frontend and backend in development mode
   npm run dev
   
   # Or start individually:
   npm run backend:dev    # Backend on http://localhost:5000
   npm run frontend:dev   # Frontend on http://localhost:3000
   ```

### Default Login Credentials

- **Username**: admin
- **Password**: admin123
- **Role**: Admin

## API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration (Admin only)
- `GET /api/auth/verify` - Token verification

### Inquiries
- `GET /api/inquiries` - List all inquiries
- `POST /api/inquiries` - Create new inquiry
- `GET /api/inquiries/:id` - Get specific inquiry
- `PUT /api/inquiries/:id` - Update inquiry
- `PATCH /api/inquiries/:id/status` - Update PM status

### Production Jobs
- `GET /api/production-jobs` - List production jobs
- `POST /api/production-jobs` - Create production job
- `GET /api/production-jobs/:jobcard` - Get job details
- `POST /api/production-jobs/:jobcard/stages` - Add stage log

### D&D Jobcards
- `GET /api/jobcards` - List D&D jobcards
- `POST /api/jobcards` - Create D&D jobcard

### Dye Bank
- `GET /api/dye-bank` - List dyes with search/filter
- `POST /api/dye-bank` - Create new dye

### Products
- `GET /api/products` - List products
- `POST /api/products` - Create product
- `GET /api/products/:sku/bom` - Get product BOM

## Database Schema

The system uses a professional relational database with the following key tables:

- **users**: Authentication and authorization
- **inquiries**: Sales inquiry tracking
- **dd_jobcards**: Design & Development projects
- **dye_bank**: Master component library
- **products**: Finished product catalog
- **bom**: Bill of Materials recipes
- **production_jobs**: Live workshop jobs
- **stage_logs**: Detailed production history

## Workflow Overview

1. **Sales Inquiry**: Sales team submits customer requirements
2. **PM Review**: Production Manager reviews and decides on new vs repeat
3. **D&D Process**: For new items, designers create required dyes
4. **Production Planning**: PM generates production jobcards with BOM
5. **Workshop Execution**: Workers scan QR codes and track progress
6. **Quality Control**: Stage-by-stage quality checks and logging
7. **Completion**: Final dispatch and record keeping

## Security Features

- JWT-based authentication
- Role-based access control
- Rate limiting on API endpoints
- Input validation and sanitization
- Secure password hashing (bcrypt)
- CORS protection

## Development

### Project Structure
```
nakshita-jewellers-erp/
├── backend/                 # Node.js/Express API
│   ├── src/
│   │   ├── models/         # Database models
│   │   ├── routes/         # API endpoints
│   │   ├── controllers/    # Business logic
│   │   ├── middleware/     # Authentication, validation
│   │   └── utils/          # Helper functions
│   └── scripts/            # Database scripts
├── frontend/               # React/Vite application
│   ├── src/
│   │   ├── components/     # Reusable components
│   │   ├── pages/          # Route components
│   │   ├── hooks/          # Custom React hooks
│   │   └── utils/          # Frontend utilities
├── database/               # Database schemas and migrations
└── docs/                   # Documentation
```

### Available Scripts

```bash
# Development
npm run dev                 # Start both frontend and backend
npm run backend:dev         # Start backend only
npm run frontend:dev        # Start frontend only

# Production
npm run build              # Build frontend for production
npm start                  # Start production server

# Installation
npm run install-all        # Install all dependencies
npm run backend:install    # Install backend dependencies
npm run frontend:install   # Install frontend dependencies
```

## Deployment

The application is designed for deployment on platforms like:
- **Backend**: Heroku, DigitalOcean, AWS
- **Database**: PostgreSQL on cloud providers
- **Frontend**: Netlify, Vercel, or served by backend

### Environment Variables

Configure the following environment variables for production:

```
NODE_ENV=production
PORT=5000
DB_HOST=your-database-host
DB_NAME=nakshita_jewellers_erp
DB_USER=your-database-user
DB_PASSWORD=your-database-password
JWT_SECRET=your-secure-jwt-secret
EMAIL_HOST=your-smtp-host
EMAIL_USER=your-email-user
EMAIL_PASSWORD=your-email-password
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation in the `/docs` folder

## Future Enhancements

- Mobile app for workshop tracking
- Advanced reporting and analytics
- Integration with accounting systems
- Barcode printing capabilities
- Customer portal for order tracking
- Inventory management system
- Advanced CAD file management
- Multi-location support