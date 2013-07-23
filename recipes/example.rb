directory "/root/.ssh" do
	owner "root"
	group "root"
	mode 00755
	action :create
end

cybera_append_template "/root/.ssh/config" do
	source "example.erb"
end