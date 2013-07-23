actions :create

default_action :create

attribute :file_path,   :kind_of => String, :name_attribute => true
attribute :source,			:kind_of => String, :required => true
attribute :owner,				:kind_of => [Integer, String]
attribute :group, 			:kind_of => [Integer, String]
attribute :mode,				:kind_of => [Integer, String]

attribute :append_name, :kind_of => String, :regex => /^[^\s\/]+$/
attribute :append_index, :kind_of => Integer
