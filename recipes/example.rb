directory "/root/.ssh" do
	owner "root"
	group "root"
	mode 00755
	action :create
end

cybera_append_template "localhost" do
	path "/root/.ssh/config"
	source "example.erb"
	variables(
		:hostname => "127.0.0.1"
	)
end

cybera_append_template "otherhost" do
	path "/root/.ssh/config"
	source "example.erb"
	variables(
		:hostname => "10.0.0.3",
		:extra_config => [
			"ForwardAgent yes",
			"User ubuntu"
		]
	)
end