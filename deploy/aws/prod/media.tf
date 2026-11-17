# Images for published content (article covers, recipe photos, expert
# photos, exercise images), uploaded in the admin panel.
#
# The bucket is private and nobody but the server reads it. The server
# writes uploads under `uploads/` with the task role (no access keys) and
# copies an image to `public/` only while published content uses it; it
# serves those copies itself at https://<domain>/media/<id>.jpg
# (parla_server/lib/src/web). Every image was re-encoded by the server, so
# no camera or location metadata is stored.

resource "aws_s3_bucket" "media" {
  bucket_prefix = "${var.name}-media-"
  force_destroy = false
}

resource "aws_s3_bucket_public_access_block" "media" {
  bucket                  = aws_s3_bucket.media.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "media" {
  bucket = aws_s3_bucket.media.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "media" {
  bucket = aws_s3_bucket.media.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Only TLS connections, even from inside AWS.
data "aws_iam_policy_document" "media_bucket" {
  statement {
    sid       = "TlsOnly"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.media.arn, "${aws_s3_bucket.media.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "media" {
  bucket     = aws_s3_bucket.media.id
  policy     = data.aws_iam_policy_document.media_bucket.json
  depends_on = [aws_s3_bucket_public_access_block.media]
}

# The server stores, reads, copies and deletes images.
data "aws_iam_policy_document" "task_media" {
  statement {
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.media.arn}/*"]
  }
}

resource "aws_iam_role_policy" "task_media" {
  name   = "media"
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task_media.json
}
