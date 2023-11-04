# -----------------------------------
# S3
# -----------------------------------
# TODO s3 cross region replicationの実装。
# ランダムID生成
# "random_string"の使用は公式非推奨
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_id" "s3" {
  byte_length = 8
  keepers = { # Generate a new bucket with a random numbers name each time when the following setting below changes.
    region = var.main_region
  }
}
# public bucket
# TODO 静的ウェブサイトのホスティングをALBを実装するタイミングで実装する。
resource "aws_s3_bucket" "public_assets" { # versioningをこの中で使用する事は公式非推奨。そのため、"aws_s3_bucket_versioning"内で実装。
  bucket = format("%s-public-assets-%s", var.env_name, random_id.s3.hex)
  tags = {
    Name = format("%s-public-assets-%s", var.env_name, random_id.s3.hex)
  }
}
resource "aws_s3_bucket_versioning" "public_assets_versioning" {
  bucket = aws_s3_bucket.public_assets.id
  versioning_configuration {
    status = "Disabled"
  }
}
resource "aws_s3_bucket_public_access_block" "public_ab" {
  bucket                  = aws_s3_bucket.public_assets.id
  block_public_acls       = true
  block_public_policy     = false # S3バケットを自動作成する処理の中で、block_public_policyはデフォルトtrueなのでfalseにしないと新規作成時でも設定したポリシーの適応が失敗し構築が失敗する。
  ignore_public_acls      = true
  restrict_public_buckets = false
  depends_on = [
    aws_s3_bucket.public_assets
  ]
}
resource "aws_s3_bucket_policy" "public_assets_policy" {
  bucket = aws_s3_bucket.public_assets.id
  policy = data.aws_iam_policy_document.allow_access_from_public.json
  depends_on = [
    aws_s3_bucket_public_access_block.public_ab
  ]
}
data "aws_iam_policy_document" "allow_access_from_public" {
  statement {
    effect = "Allow" # デフォルトは"Allow"
    principals {     # 公式より右記を抜粋。"To have Terraform render JSON containing "Principal": {"AWS": "*"}, use type = "AWS" and identifiers = ["*"]."
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "S3:GetObject",
    ]
    resources = [
      aws_s3_bucket.public_assets.arn,       # buckerそのものへのアクセス
      "${aws_s3_bucket.public_assets.arn}/*" # bucket内のオブジェクトへのアクセス
    ]
  }
}
# TODO ドメインが確定したらCORSの設定を行う
/*
resource "aws_s3_bucket_cors_configuration" "public_assets_cors" {
  bucket = aws_s3_bucket.public_assets_cors.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://domainname.com", "http://localhost:port"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}
*/


# private bucket for admin use
resource "aws_s3_bucket" "private_admin" { # versioningをこの中で使用する事は公式非推奨。そのため、"aws_s3_bucket_versioning"内で実装。
  bucket = format("%s-private-admin-%s", var.env_name, random_id.s3.hex)
  tags = {
    Name = format("%s-private-admin-%s", var.env_name, random_id.s3.hex)
  }
}
resource "aws_s3_bucket_versioning" "private_admin_versioning" {
  bucket = aws_s3_bucket.private_admin.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_public_access_block" "private_admin_ab" {
  bucket                  = aws_s3_bucket.private_admin.id
  block_public_acls       = true
  block_public_policy     = false # S3バケットを自動作成する処理の中で、block_public_policyはデフォルトtrueなのでfalseにしないと新規作成時でも設定したポリシーの適応が失敗し構築が失敗する。
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on = [
    aws_s3_bucket.private_admin
  ]
}
resource "aws_s3_bucket_policy" "private_admin_policy" {
  bucket = aws_s3_bucket.private_admin.id
  policy = data.aws_iam_policy_document.limited_access_only_private_admin.json
  depends_on = [
    aws_s3_bucket_public_access_block.private_admin_ab
  ]
}
data "aws_iam_policy_document" "limited_access_only_private_admin" {
  statement {
    effect = "Allow" # デフォルトは"Allow"
    principals {     # 特定のadminユーザを許可。
      type        = "AWS"
      identifiers = [var.admin_iam_arn]
    }
    actions = [
      "S3:*",
    ]
    resources = [
      aws_s3_bucket.private_admin.arn,       # buckerそのものへのアクセス
      "${aws_s3_bucket.private_admin.arn}/*" # bucket内のオブジェクトへのアクセス
    ]
  }
}
# private bucket for system logs use



/*
resource "aws_s3_bucket_lifecycle_configuration" "private_sys_logs_lifecycle" {
  bucket = aws_s3_bucket.private_sys_logs.id
  rule {
    id     = "private_sys_logs"
    status = "Enabled"
    expiration {
      days = 90
    }
    filter { # prefixを指定しない場合必須。(ここでいうprefixとは、filter内prefixではなく、filterと同列に配置できるprefix。)lifecycle ruleを適応する適用する範囲を指定。ここでは全てを指定。
      prefix = ""
    }
  }
}
*/
# private bucket for system logs loop avoidance use
# TODO loopを防ぐ実装を必要になったタイミングで行う