resource "aws_organizations_organizational_unit" "workloads" {
  name      = "workloads"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}
