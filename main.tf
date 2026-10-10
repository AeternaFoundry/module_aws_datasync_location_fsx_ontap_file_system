resource "aws_datasync_location_fsx_ontap_file_system" "datasync_location_fsx_ontap_file_systems" {
  for_each = var.datasync_location_fsx_ontap_file_systems

  security_group_arns         = each.value.security_group_arns
  storage_virtual_machine_arn = each.value.storage_virtual_machine_arn
  region                      = each.value.region
  subdirectory                = each.value.subdirectory
  tags                        = each.value.tags
  tags_all                    = each.value.tags_all

  protocol {
    dynamic "nfs" {
      for_each = each.value.protocol.nfs != null ? [each.value.protocol.nfs] : []
      content {
        mount_options {
          version = nfs.value.mount_options.version
        }
      }
    }
    dynamic "smb" {
      for_each = each.value.protocol.smb != null ? [each.value.protocol.smb] : []
      content {
        domain = smb.value.domain
        mount_options {
          version = smb.value.mount_options.version
        }
        password = smb.value.password
        user     = smb.value.user
      }
    }
  }
}

