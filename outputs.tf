output "directory" {
  value       = aws_directory_service_directory.this
  sensitive   = true
  description = "The aws_directory_service resource"
}

output "file_system" {
  value       = aws_fsx_windows_file_system.this
  description = "The aws_fsx_windows_file_system resource"
}
