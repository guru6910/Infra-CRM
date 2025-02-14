# Create an S3 bucket
resource "aws_s3_bucket" "cbz_bucket" {
  bucket = "cbz-frontend-b18" # Replace with a globally unique bucket name

  tags = {
    Name = "StaticWebsiteBucket"
    env  = "dev"
  }
}

# Configure static website hosting (Replaces the deprecated "website" block)
resource "aws_s3_bucket_website_configuration" "cbz_website_config" {
  bucket = aws_s3_bucket.cbz_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
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

# Output the bucket's website endpoint (Updated)
output "website_endpoint" {
  value       = aws_s3_bucket_website_configuration.cbz_website_config.website_endpoint
  description = "The URL to access the static website"
}
