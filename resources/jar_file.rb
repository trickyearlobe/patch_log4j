require 'zip'

unified_mode true if respond_to? :unified_mode
resource_name :jar_file
provides :jar_file

property :filename, String, name_property: true
property :classes_to_remove, Array

action :remove_classes do
  zip = Zip::File.open(new_resource.filename)
  new_resource.classes_to_remove.each do |class_to_remove|
    if file_to_remove = zip.entries.map{|e| e.name}.select{|e| e.match class_to_remove}.first
      converge_by("Remove class #{file_to_remove}") do
        zip.remove(file_to_remove)
      end
    end
  end
  zip.close
end
