-- Drop the existing database and create it again (if needed)
SOURCE ./html/sql/table_creation.sql;

-- Populate initial sample data
SOURCE ./html/sql/populate_sample_data.sql;

-- Create procedures for adding customer partners
SOURCE ./html/sql/partner_customer_create.sql;

-- Create procedures for adding supplier partners
SOURCE ./html/sql/partner_supplier_create.sql;

-- Create procedures for updating partner details
SOURCE ./html/sql/partner_update.sql;

-- Create procedures for deleting partners
SOURCE ./html/sql/partner_delete.sql;

-- Retrieve partner records (for data verification or display)
SOURCE ./html/sql/partner_retreive.sql;