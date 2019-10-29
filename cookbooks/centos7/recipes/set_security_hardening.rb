# frozen_string_literal: true

######################################################
# No Chef resource or Ruby class method configures file attributes
######################################################
bash 'set_immutable_attribute_to_target_files' do
  code <<-EOH
    chattr +i /etc/services
    chattr +i /etc/passwd
    chattr +i /etc/shadow
  EOH
  action :run
end

######################################################
# No Chef resource or Ruby class method configures file attributes
# FileUtils.chmod_R 0644, "/home" changed directories including files
######################################################
bash 'set_home_files_to_644' do
  code <<-EOH
    find /home -type f -exec chmod 644 {} \\;
  EOH
  action :run
end
