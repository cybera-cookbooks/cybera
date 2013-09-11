def whyrun_supported?
  true
end

action :create do
	file_path = new_resource.path
	owner = new_resource.owner || ( ::File.exist?(file_path) ? ::File.stat(file_path).uid : "root" )
	group = new_resource.group || ( ::File.exist?(file_path) ? ::File.stat(file_path).gid : "root" )
	mode = new_resource.mode || ( ::File.exist?(file_path) ? ("%05o" % ::File.stat(file_path).mode)[-5..-1] : 00644)
	existing_content = ::File.exist?(file_path) ? IO.read(file_path) : ""

	append_directory_path = "#{file_path}.d.chef"
	append_label = new_resource.label || new_resource.source.gsub(".erb", "")
	# If the append directory hasn't been created, the call to next_index will return 1, which happens to be
	# what we want as the next index in that case (as we're already creating a 0 index file). If this changes,
	# we'd have to be smarter and call the next_index method again after we've created the directory and created
	# any initial indexed files in it.
	append_order = "%03i" % (new_resource.order || next_index(append_directory_path))
	append_path = Dir.glob("#{append_directory_path}/*_#{append_label}").first || "#{append_directory_path}/#{append_order}_#{append_label}"

	begin
		run_context.resource_collection.lookup("directory[#{append_directory_path}]")
	rescue Chef::Exceptions::ResourceNotFound
		directory append_directory_path do
			owner owner
			group group
			mode mode # Best way to compute equivalent directory permissions for a folder?
			action :nothing
		end.run_action(:create)
	end

	begin
		run_context.resource_collection.lookup("file[#{append_directory_path}/000_#{::File.basename(file_path)}]")
	rescue Chef::Exceptions::ResourceNotFound
		file "#{append_directory_path}/000_#{::File.basename(file_path)}" do
			owner owner
			group group
			mode mode
			content existing_content
			action :nothing
		end.run_action(:create_if_missing)
	end

	template append_path do
		source new_resource.source # How to make sure this path is relative to the cookbook we're calling *from*?
		cookbook new_resource.cookbook_name.to_s
		owner owner
		group group
		mode mode
		variables(new_resource.variables)
		action :nothing
	end.run_action(:create)

	template "re-concatenate #{file_path} - #{append_label}" do
		path file_path
		source "compile.erb"
		cookbook "cybera"
		owner owner
		group group
		mode mode
		variables(
			:include_files => Dir.glob("#{append_directory_path}/*").sort
		)
	end
end

private
	
	def next_index(append_dir_path)
		Dir.glob("#{append_dir_path}/*").sort.map do |path| 
			basename = ::File.basename(path)
			basename.gsub(/(\d{3})_.+/,'\1')
		end.last.to_i + 1
	end
