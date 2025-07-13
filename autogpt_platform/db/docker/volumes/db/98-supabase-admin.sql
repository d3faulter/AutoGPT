-- Create supabase_admin user for services that need it
\set pgpass `echo "$POSTGRES_PASSWORD"`

-- Create supabase_admin user if it doesn't exist
DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles 
      WHERE rolname = 'supabase_admin') THEN
      
      CREATE ROLE supabase_admin WITH LOGIN PASSWORD :'pgpass';
   END IF;
END
$do$;

-- Grant necessary permissions to supabase_admin
ALTER USER supabase_admin WITH PASSWORD :'pgpass';
GRANT CONNECT ON DATABASE postgres TO supabase_admin;
GRANT CONNECT ON DATABASE _supabase TO supabase_admin;
GRANT USAGE ON SCHEMA public TO supabase_admin;
GRANT USAGE ON SCHEMA _supabase TO supabase_admin;
GRANT USAGE ON SCHEMA _analytics TO supabase_admin;
GRANT ALL PRIVILEGES ON DATABASE _supabase TO supabase_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA _analytics TO supabase_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA _analytics TO supabase_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA _analytics TO supabase_admin;

-- Make supabase_admin a superuser for full access (needed for some Supabase operations)
ALTER USER supabase_admin WITH SUPERUSER;
