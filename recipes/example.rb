directory "/root/.ssh" do
	owner "root"
	group "root"
	mode 00755
	action :create
end

cybera_append_template "/root/.ssh/config" do
	source "example.erb"
	variables(
		:hostname => "127.0.0.1"
	)
end

cybera_append_template "/root/.ssh/config - 10.0.0.3" do
	path "/root/.ssh/config"
	label "otherhost"
	source "example.erb"
	variables(
		:hostname => "10.0.0.3",
		:extra_config => [
			"ForwardAgent yes",
			"User ubuntu"
		]
	)
end