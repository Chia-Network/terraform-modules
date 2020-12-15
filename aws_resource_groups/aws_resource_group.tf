resource "aws_resourcegroups_group" "resource_group" {
  name = "${var.application}-${var.branch}-${var.tag_name}"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "application",
      "Values": ["${var.application}"],
      "Key": "branch",
      "Values": ["${var.branch}"]
    }
  ]
}
JSON
  }
}
