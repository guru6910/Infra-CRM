# Create an S3 bucket
resource "aws_s3_bucket" "cbz_bucket" {
  bucket = "cbz-frontend-b18" # Replace with a globally unique bucket name

  # Enable static website hosting
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "StaticWebsiteBucket"
    env = "dev"
  }
}

# Disable Block Public Access
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.cbz_bucket.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
# Set the bucket policy to allow public read access (use cautiously)
resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.cbz_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.cbz_bucket.arn}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.example]
}

# Output the bucket's website endpoint
output "website_endpoint" {
  value       = aws_s3_bucket.cbz_bucket.website_endpoint
  description = "The URL to access the static website"
}
