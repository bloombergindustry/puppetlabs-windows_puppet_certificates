# @param cert_path
#   The path to the certificate file
# @param cert_type
#   The type of certificate being acted upon.
#   Valid values are `trusted_root_ca` and `personal`
# @param ensure
#   Currently only `present` is supported
#   Default: present
# @param key_path
#   The path to the key file
define windows_puppet_certificates::windows_certificate (
  Stdlib::Windowspath $cert_path,
  Enum['trusted_root_ca', 'personal'] $cert_type,
  Enum['present'] $ensure = 'present',
  Optional[Stdlib::Windowspath] $key_path,
) {

  $common  = epp("${module_name}/puppet_certs_common.ps1")
  $command = epp("${module_name}/puppet_certs_command.ps1", {
    cert_path => $cert_path,
    key_path  => $key_path,
    cert_type => $cert_type,
  })
  $onlyif  = epp("${module_name}/puppet_certs_onlyif.ps1", {
    cert_path => $cert_path,
    cert_type => $cert_type,
  })

  exec { $name:
    command  => "${common}${command}",
    onlyif   => "${common}${onlyif}",
    provider => powershell,
  }
}
