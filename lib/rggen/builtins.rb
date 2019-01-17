require_relative 'builtins/loaders/configuration/json_loader'
require_relative 'builtins/loaders/configuration/yaml_loader'
require_relative 'builtins/loaders/register_map/csv_loader'
require_relative 'builtins/loaders/register_map/xls_loader'
require_relative 'builtins/loaders/register_map/xlsx_ods_loader'

require_relative 'builtins/global/address_width'
require_relative 'builtins/global/data_width'

require_relative 'builtins/bit_field/bit_assignment'
require_relative 'builtins/bit_field/field_model'
require_relative 'builtins/bit_field/initial_value'
require_relative 'builtins/bit_field/name'
require_relative 'builtins/bit_field/reference'
require_relative 'builtins/bit_field/rtl_top'
require_relative 'builtins/bit_field/type'
require_relative 'builtins/bit_field/types/rw'
require_relative 'builtins/bit_field/types/rwl_rwe'
require_relative 'builtins/bit_field/types/ro'
require_relative 'builtins/bit_field/types/w0c_w1c'
require_relative 'builtins/bit_field/types/w0s_w1s'
require_relative 'builtins/bit_field/types/wo'
require_relative 'builtins/bit_field/types/reserved'

require_relative 'builtins/register/array'
require_relative 'builtins/register/constructor'
require_relative 'builtins/register/field_model_creator'
require_relative 'builtins/register/indirect_index_configurator'
require_relative 'builtins/register/offset_address'
require_relative 'builtins/register/name'
require_relative 'builtins/register/reg_model'
require_relative 'builtins/register/rtl_top'
require_relative 'builtins/register/sub_block_model'
require_relative 'builtins/register/type'
require_relative 'builtins/register/types/external'
require_relative 'builtins/register/types/indirect'
require_relative 'builtins/register/uniqueness_validator'

require_relative 'builtins/register_block/address_struct'
require_relative 'builtins/register_block/base_address'
require_relative 'builtins/register_block/block_model'
require_relative 'builtins/register_block/byte_size'
require_relative 'builtins/register_block/c_header_file'
require_relative 'builtins/register_block/clock_reset'
require_relative 'builtins/register_block/constructor'
require_relative 'builtins/register_block/default_map_creator'
require_relative 'builtins/register_block/host_if'
require_relative 'builtins/register_block/host_ifs/apb'
require_relative 'builtins/register_block/host_ifs/axi4lite'
require_relative 'builtins/register_block/name'
require_relative 'builtins/register_block/ral_package'
require_relative 'builtins/register_block/rtl_top'
require_relative 'builtins/register_block/sub_model_creator'
