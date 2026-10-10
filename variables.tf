variable "datasync_location_fsx_ontap_file_systems" {
  description = <<EOT
Map of datasync_location_fsx_ontap_file_systems, attributes below
Required:
    - security_group_arns
    - storage_virtual_machine_arn
    - protocol (block):
        - nfs (optional, block):
            - mount_options (required, block):
                - version (optional)
        - smb (optional, block):
            - domain (optional)
            - mount_options (required, block):
                - version (optional)
            - password (required)
            - user (required)
Optional:
    - region
    - subdirectory
    - tags
    - tags_all
EOT

  type = map(object({
    security_group_arns         = set(string)
    storage_virtual_machine_arn = string
    region                      = optional(string)
    subdirectory                = optional(string)
    tags                        = optional(map(string))
    tags_all                    = optional(map(string))
    protocol = object({
      nfs = optional(object({
        mount_options = object({
          version = optional(string)
        })
      }))
      smb = optional(object({
        domain = optional(string)
        mount_options = object({
          version = optional(string)
        })
        password = string
        user     = string
      }))
    })
  }))
  validation {
    condition = alltrue([
      for k, v in var.datasync_location_fsx_ontap_file_systems : (
        v.subdirectory == null || (length(v.subdirectory) >= 1 && length(v.subdirectory) <= 4096)
      )
    ])
    error_message = "must be between 1 and 4096 characters"
  }
  # Note: 7 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

