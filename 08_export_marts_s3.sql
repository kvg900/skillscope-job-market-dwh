-- Step 8: Export marts to Amazon S3 as Parquet (data-lake serving layer)
-- Run after Step 7. Replace YOUR_BUCKET_NAME.
-- Parquet is columnar + compressed, so S3 storage and scan cost stay tiny.

COPY flat_mart.job_postings
  TO 's3://YOUR_BUCKET_NAME/marts/flat_mart/job_postings.parquet' (FORMAT PARQUET, COMPRESSION ZSTD);

COPY skills_mart.dim_skill
  TO 's3://YOUR_BUCKET_NAME/marts/skills_mart/dim_skill.parquet' (FORMAT PARQUET);
COPY skills_mart.dim_date_month
  TO 's3://YOUR_BUCKET_NAME/marts/skills_mart/dim_date_month.parquet' (FORMAT PARQUET);
COPY skills_mart.fact_skill_demand_monthly
  TO 's3://YOUR_BUCKET_NAME/marts/skills_mart/fact_skill_demand_monthly.parquet' (FORMAT PARQUET);

COPY priority_mart.priority_roles
  TO 's3://YOUR_BUCKET_NAME/marts/priority_mart/priority_roles.parquet' (FORMAT PARQUET);
COPY priority_mart.priority_jobs_snapshot
  TO 's3://YOUR_BUCKET_NAME/marts/priority_mart/priority_jobs_snapshot.parquet' (FORMAT PARQUET);

COPY company_mart.fact_company_hiring_monthly
  TO 's3://YOUR_BUCKET_NAME/marts/company_mart/fact_company_hiring_monthly.parquet' (FORMAT PARQUET);

-- Verify: read one back straight from S3
SELECT 'S3 export check' AS info, COUNT(*) AS rows_in_s3
FROM read_parquet('s3://YOUR_BUCKET_NAME/marts/skills_mart/fact_skill_demand_monthly.parquet');
