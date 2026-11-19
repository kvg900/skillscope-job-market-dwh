#!/usr/bin/env bash
# One-time: copy the 4 source CSVs into your own S3 bucket.
# Usage: ./upload_raw_to_s3.sh YOUR_BUCKET_NAME ap-south-1
set -euo pipefail
BUCKET="${1:?bucket name}"; REGION="${2:-ap-south-1}"
SRC="https://storage.googleapis.com/sql_de"

aws s3 mb "s3://$BUCKET" --region "$REGION" 2>/dev/null || true
# keep the bucket private
aws s3api put-public-access-block --bucket "$BUCKET" \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

mkdir -p raw_tmp
for f in company_dim skills_dim job_postings_fact skills_job_dim; do
  curl -fSL "$SRC/$f.csv" -o "raw_tmp/$f.csv"
  aws s3 cp "raw_tmp/$f.csv" "s3://$BUCKET/raw/$f.csv"
done
rm -rf raw_tmp
aws s3 ls "s3://$BUCKET/raw/"
