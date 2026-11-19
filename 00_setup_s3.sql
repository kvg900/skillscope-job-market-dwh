-- Step 0: AWS - Configure DuckDB to read/write Amazon S3
-- Run this first (build_dw_marts.sql already does)
-- Prereq: run `aws configure` (or export AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY)
--         so no credentials are ever hard-coded in this repo.

INSTALL httpfs;
LOAD httpfs;
INSTALL aws;
LOAD aws;

-- Picks up credentials from env vars, ~/.aws/credentials, or an IAM role (e.g. on EC2)
CREATE OR REPLACE SECRET s3_secret (
    TYPE s3,
    PROVIDER credential_chain,
    REGION 'ap-south-1'          -- change to your bucket's region
);

-- Small-instance friendly settings (e.g. EC2 t3.micro with 1 GB RAM)
-- SET memory_limit = '700MB';
-- SET temp_directory = '/tmp/duckdb_tmp';
