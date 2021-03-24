resource "aws_ecr_repository" "flask_app" {
  name = var.ecr_repository_name
  image_scanning_configuration   {
    scan_on_push = true
  }
}

data "aws_ecr_image" "flask_latest_image" {
  repository_name = aws_ecr_repository.flask_app.name
  image_tag       = "latest"
}

data "template_file" "codebuild_buildspec" {
  template = file("${path.module}/codebuild_buildspec.yaml.tpl")
  vars = {
    repository_uri = aws_ecr_repository.flask_app.repository_url
  }
}

resource "local_file" "render_buildspec" {
  content     = data.template_file.web_deployment_yaml.rendered
  filename 	= "${path.module}/codebuild_buildspec.yaml"
}

resource "aws_iam_role" "codebuild_for_webapp" {
  name = var.codebuild_role_name
  path  = "/service-role/"
  assume_role_policy = jsonencode(
  {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal =  {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  }
  )
}


data "aws_iam_policy" "ecr_poweruser_access" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "codebuild-ecr-policy-attach" {
  role       = aws_iam_role.codebuild_for_webapp.name
  policy_arn = data.aws_iam_policy.ecr_poweruser_access.arn
}

resource "aws_codebuild_project" "pipeline" {

  name          = var.codebuild_project_name
  description   = ""
  build_timeout = 60
  service_role  = aws_iam_role.codebuild_for_webapp.arn

  artifacts {
    type                   = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = ""
      status      = "ENABLED"
      stream_name = ""
    }

    s3_logs {
      encryption_disabled = false
      location            = ""
      status              = "DISABLED"
    }

  }

  source {
    buildspec       = file(local_file.render_buildspec.filename)
    git_clone_depth = 1
    git_submodules_config {
      fetch_submodules = false
    }
    insecure_ssl        = false
    location            = data.github_repository.flask_app.html_url
    report_build_status = false
    type                = "GITHUB"
  }
}

resource "aws_codebuild_webhook" "pipeline_webhook" {
  project_name = aws_codebuild_project.pipeline.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH, PULL_REQUEST_MERGED"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "^refs/heads/main$"
    }
  }
}

data "github_repository" "flask_app" {
  full_name = "${var.github_owner_username}/${var.github_repository}"
}

resource "github_repository_webhook" "flask_app_webhook" {
  repository = data.github_repository.flask_app.name
  active     = true
  events     = ["push","pull_request"]
  configuration {
    url          = aws_codebuild_webhook.pipeline_webhook.payload_url
    secret       = aws_codebuild_webhook.pipeline_webhook.secret
    content_type = "json"
    insecure_ssl = false
  }
}


resource "null_resource" "trigger_codebuild" {
  provisioner "local-exec" {
    command = "aws codebuild start-build --project-name test-build"
  }
  depends_on = [aws_codebuild_project.pipeline]
}

data "template_file" "web_deployment_yaml" {
  template = file("${path.module}/kube/web.yaml.tpl")
  vars = {
    web_image_uri = "${data.aws_ecr_image.flask_latest_image.repository_name}:${data.aws_ecr_image.flask_latest_image.image_tag}"
  }
}

resource "local_file" "render_web_deploy_yaml" {
  content     = data.template_file.web_deployment_yaml.rendered
  filename 	= "${path.module}/web.yaml"
}
