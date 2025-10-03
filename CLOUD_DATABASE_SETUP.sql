-- Complete Database Setup for Cloud Deployment
-- Copy and paste this ENTIRE script into your DigitalOcean database console

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table for authentication and authorization
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

-- Inquiries table - tracks initial sales leads
CREATE TABLE IF NOT EXISTS inquiries (
    inquiry_id VARCHAR(20) PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    client_name VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    product_type VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    polish_color VARCHAR(50),
    special_note TEXT,
    reference_image_url TEXT,
    inquiry_owner VARCHAR(100) NOT NULL,
    pm_status VARCHAR(20) CHECK (pm_status IN ('Pending Review', 'In Progress', 'Finalized', 'On Hold', 'Cancelled')) NOT NULL DEFAULT 'Pending Review',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- D&D Jobcards table
CREATE TABLE IF NOT EXISTS dd_jobcards (
    jobcard_no VARCHAR(20) PRIMARY KEY,
    inquiry_id VARCHAR(20) NOT NULL REFERENCES inquiries(inquiry_id) ON DELETE CASCADE,
    project_name VARCHAR(255) NOT NULL,
    date_created DATE NOT NULL DEFAULT CURRENT_DATE,
    designer_assigned VARCHAR(100) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Assigned', 'In Progress', 'Completed', 'On Hold', 'Cancelled')) NOT NULL DEFAULT 'Assigned',
    description TEXT,
    expected_completion_date DATE,
    actual_completion_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Dye Bank table
CREATE TABLE IF NOT EXISTS dye_bank (
    dye_sku VARCHAR(20) PRIMARY KEY,
    parent_jobcard_no VARCHAR(20) NOT NULL REFERENCES dd_jobcards(jobcard_no) ON DELETE CASCADE,
    dye_name VARCHAR(255) NOT NULL,
    dye_photo_url TEXT,
    dye_type VARCHAR(50) NOT NULL,
    tags TEXT,
    size_dimensions VARCHAR(100),
    cad_by VARCHAR(100),
    cad_completion_date DATE,
    cad_file_link TEXT,
    cam_vendor VARCHAR(100),
    cam_weight_grams DECIMAL(10, 3) CHECK (cam_weight_grams >= 0),
    final_dye_no VARCHAR(50) UNIQUE,
    dye_status VARCHAR(20) CHECK (dye_status IN ('In Development', 'CAD Complete', 'CAM Complete', 'Active', 'Retired', 'Lost', 'Damaged')) NOT NULL DEFAULT 'In Development',
    physical_location VARCHAR(100),
    notes TEXT,
    dye_cost DECIMAL(10, 2) CHECK (dye_cost >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE IF NOT EXISTS products (
    product_sku VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Active', 'Discontinued', 'Development')) NOT NULL DEFAULT 'Development',
    description TEXT,
    category VARCHAR(100),
    base_price DECIMAL(10, 2) CHECK (base_price >= 0),
    product_image_url TEXT,
    tags TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BOM table
CREATE TABLE IF NOT EXISTS bom (
    bom_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_sku VARCHAR(20) NOT NULL REFERENCES products(product_sku) ON DELETE CASCADE,
    dye_sku VARCHAR(20) NOT NULL REFERENCES dye_bank(dye_sku) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    notes TEXT,
    is_optional BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(product_sku, dye_sku)
);

-- Production Jobs table
CREATE TABLE IF NOT EXISTS production_jobs (
    jobcard_number VARCHAR(20) PRIMARY KEY,
    inquiry_id VARCHAR(20) NOT NULL REFERENCES inquiries(inquiry_id) ON DELETE CASCADE,
    product_sku VARCHAR(20) NOT NULL REFERENCES products(product_sku) ON DELETE RESTRICT,
    due_date DATE NOT NULL,
    metal_details TEXT,
    current_stage VARCHAR(100) NOT NULL DEFAULT 'Casting',
    status VARCHAR(20) CHECK (status IN ('Pending', 'In Progress', 'On Hold', 'Completed', 'Cancelled', 'Quality Check', 'Rework Required')) NOT NULL DEFAULT 'Pending',
    priority VARCHAR(10) CHECK (priority IN ('Low', 'Medium', 'High', 'Urgent')) NOT NULL DEFAULT 'Medium',
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    assigned_to VARCHAR(100),
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    estimated_hours DECIMAL(5, 2),
    actual_hours DECIMAL(5, 2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stage Log table
CREATE TABLE IF NOT EXISTS stage_logs (
    log_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    jobcard_number VARCHAR(20) NOT NULL REFERENCES production_jobs(jobcard_number) ON DELETE CASCADE,
    stage VARCHAR(100) NOT NULL,
    person VARCHAR(100) NOT NULL,
    in_weight DECIMAL(10, 3) CHECK (in_weight >= 0),
    out_weight DECIMAL(10, 3) CHECK (out_weight >= 0),
    pieces INTEGER CHECK (pieces >= 0),
    notes TEXT,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    stage_start_time TIMESTAMP,
    stage_end_time TIMESTAMP,
    quality_check VARCHAR(20) CHECK (quality_check IN ('Pass', 'Fail', 'Rework', 'Not Applicable')) NOT NULL DEFAULT 'Not Applicable',
    attachments JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_inquiries_pm_status ON inquiries(pm_status);
CREATE INDEX IF NOT EXISTS idx_inquiries_timestamp ON inquiries(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_dd_jobcards_status ON dd_jobcards(status);
CREATE INDEX IF NOT EXISTS idx_dd_jobcards_designer ON dd_jobcards(designer_assigned);
CREATE INDEX IF NOT EXISTS idx_dye_bank_status ON dye_bank(dye_status);
CREATE INDEX IF NOT EXISTS idx_dye_bank_type ON dye_bank(dye_type);
CREATE INDEX IF NOT EXISTS idx_production_jobs_status ON production_jobs(status);
CREATE INDEX IF NOT EXISTS idx_production_jobs_current_stage ON production_jobs(current_stage);
CREATE INDEX IF NOT EXISTS idx_production_jobs_due_date ON production_jobs(due_date);
CREATE INDEX IF NOT EXISTS idx_stage_logs_jobcard_timestamp ON stage_logs(jobcard_number, timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_stage_logs_stage ON stage_logs(stage);
CREATE INDEX IF NOT EXISTS idx_stage_logs_person ON stage_logs(person);

-- Create function for updating timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at columns
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_inquiries_updated_at BEFORE UPDATE ON inquiries FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dd_jobcards_updated_at BEFORE UPDATE ON dd_jobcards FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dye_bank_updated_at BEFORE UPDATE ON dye_bank FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_bom_updated_at BEFORE UPDATE ON bom FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_production_jobs_updated_at BEFORE UPDATE ON production_jobs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_stage_logs_updated_at BEFORE UPDATE ON stage_logs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

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

-- Insert sample data for testing (optional)
INSERT INTO inquiries (inquiry_id, client_name, city, contact_number, product_type, quantity, polish_color, inquiry_owner) 
VALUES (
    'NJI-25-001', 
    'Sample Customer', 
    'Mumbai', 
    '9876543210', 
    'Rings', 
    2, 
    'Yellow Gold', 
    'Demo Sales Person'
) ON CONFLICT (inquiry_id) DO NOTHING;

-- Success message
SELECT 'Database setup completed successfully! You can now login with username: admin, password: admin123' as message;