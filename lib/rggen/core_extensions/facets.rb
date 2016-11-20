require 'facets/enumerable/exclude'
require 'facets/enumerable/sum'
require 'facets/file/ext'
require 'facets/hash/symbolize_keys'
require 'facets/integer/multiple'
require 'facets/kernel/attr_singleton'
require 'facets/kernel/not'
require 'facets/kernel/not_nil'
require 'facets/method/curry' unless Method.public_method_defined?(:curry)
require 'facets/module/attr_setter'
require 'facets/numeric/positive'
require 'facets/object/itself' unless Object.public_method_defined?(:itself)
require 'facets/pathname/to_path'
require 'facets/pathname/to_str'
require 'facets/range/overlap'
require 'facets/regexp/op_add'
require 'facets/regexp/op_or'
require 'facets/string/indent'
require 'facets/string/quote'
require 'facets/string/variablize'
require 'facets/symbol/variablize'
