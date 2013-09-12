actions :create

default_action :create

attribute :path,  			:kind_of => String, :required => true
attribute :source,			:kind_of => String, :required => true
attribute :owner,				:kind_of => [Integer, String]
attribute :group, 			:kind_of => [Integer, String]
attribute :mode,				:kind_of => [Integer, String]
attribute :variables,		:kind_of => Hash

attribute :label, :kind_of => String, :regex => /^[^\s\/]+$/, :name_attribute => true, :required => true
attribute :order, :kind_of => Integer
