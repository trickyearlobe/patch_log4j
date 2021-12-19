#
# Cookbook:: patch_log4j
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

Chef::Log.info "Scanning for JAR's and WAR's that may contain Log4j badness"
if node['os'] == 'windows'
  node.default['patch_log4j']['files_to_scan'] = powershell_out('[System.IO.DriveInfo]::GetDrives() | Where-Object -Property DriveType -eq Fixed | foreach { (Get-ChildItem $_.Name -Include "log4j-core*.jar", "*.war" -Recurse -ErrorAction SilentlyContinue).FullName }').stdout.split(/\r?\n/)
else
  node.default['patch_log4j']['files_to_scan'] = shell_out("df -lP | awk {'if (NR!=1) print $6'} | xargs -I FILESYSTEM find FILESYSTEM -xdev -name 'log4j-core*.jar' -o -name '*.war'").stdout.split(/\r?\n/)
end

# Persist the JARs and WARs in the node object for viewing in Automate
node.default['patch_log4j']['jars'] = node['patch_log4j']['files_to_scan'].select{|e| File.extname(e)=='.jar'}.uniq
node.default['patch_log4j']['wars'] = node['patch_log4j']['files_to_scan'].select{|e| File.extname(e)=='.war'}.uniq

# Now patch the JARs
node['patch_log4j']['jars'].each do |jarfile|
  jar_file(jarfile) do
    classes_to_remove ['JndiLookup.class']
    action :remove_classes
  end
end

# We will patch the WARs later if we can work out how to do it safely !!!
# node['patch_log4j']['wars'].each do |warfile|
#   war_file_jarfile(warfile) do
#     jars_to_patch ['log4j-core.*']
#     classes_to_remove ['JndiLookup.class']
#     action :remove_classes
#   end
# end

