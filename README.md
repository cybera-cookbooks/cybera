# cybera cookbook

A collection of utility LWRPs for your Chef recipes.

# Usage

cybera_append_template
----------------------

Use with a source .erb file, just as you would when creating a regular template resource. The difference with this resource is that it appends the content of your template to the file at the path specified (converting it into a more modular configuration first).

```ruby
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
```

Specifically, this will do the following at the system level:

1. Create a directory called: /root/.ssh/config.d.chef
2. Create the file /root/.ssh/config.d.chef/000_config if it doesn't already exist with the original content of /root/.ssh/config
3. Using a regular template resource, create a file at /root/.ssh/config.d.chef/001_localhost (using the resource name value of "localhost")
4. Replace /root/.ssh/config with a sorted concatenation of all files in /root/.ssh/config.d.chef

Note that appending ".d.chef" serves two purposes:

1. It indicates the similar intent of the directory to the classic ".d" directory; and
2. It makes it clear that Chef is doing something to make this work. So when someone stumbles across the directory, they aren’t surprised when a file they throw in it doesn't get automatically picked up.

# Author

Author:: Cybera (<devops@cybera.ca>)
