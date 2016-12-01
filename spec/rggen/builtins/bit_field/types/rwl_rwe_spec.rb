require_relative '../../spec_helper'

describe 'bit_fields/type/rwl_rwe' do
  include_context 'bit field type common'
  include_context 'configuration common'
  include_context 'rtl common'
  include_context 'ral common'

  before(:all) do
    enable :register_block, [:name, :byte_size]
    enable :register_block, [:clock_reset, :host_if, :response_mux]
    enable :register_block, :host_if, :apb
    enable :register, [:name, :offset_address, :array, :shadow, :external]
    enable :bit_field, [:name, :bit_assignment, :type, :initial_value, :reference]
    enable :register, :index
    enable :bit_field, :type, [:rwl, :rwe, :rw]

    @factory  = build_register_map_factory
  end

  before(:all) do
    enable :global, [:data_width, :address_width]
    ConfigurationDummyLoader.load_data({})
    @configuration  = build_configuration_factory.create(configuration_file)
  end

  after(:all) do
    clear_enabled_items
  end

  let(:configuration) do
    @configuration
  end

  describe "register_map" do
    describe "#type" do
      it ":rwl/rweを返す" do
        bit_fields  = build_bit_fields([
          [nil, "register_0", "0x00", nil, nil, nil, "bit_field_0_0", "[0]", "rwl", '0', "bit_field_1_0"],
          [nil, nil         , nil   , nil, nil, nil, "bit_field_0_1", "[1]", "rwe", '0', "bit_field_1_1"],
          [nil, "register_1", "0x04", nil, nil, nil, "bit_field_1_0", "[0]", "rw" , '0', nil            ],
          [nil, nil         , nil   , nil, nil, nil, "bit_field_1_1", "[1]", "rw" , '0', nil            ]
        ])
        expect(bit_fields[0].type).to be :rwl
        expect(bit_fields[1].type).to be :rwe
      end
    end

    it "アクセス属性はread-write" do
      bit_fields  = build_bit_fields([
        [nil, "register_0", "0x00", nil, nil, nil, "bit_field_0_0", "[0]", "rwl", '0', "bit_field_1_0"],
        [nil, nil         , nil   , nil, nil, nil, "bit_field_0_1", "[1]", "rwe", '0', "bit_field_1_1"],
        [nil, "register_1", "0x04", nil, nil, nil, "bit_field_1_0", "[0]", "rw" , '0', nil            ],
        [nil, nil         , nil   , nil, nil, nil, "bit_field_1_1", "[1]", "rw" , '0', nil            ]
      ])
      expect(bit_fields[0]).to match_access :read_write
      expect(bit_fields[1]).to match_access :read_write
    end

    it "任意のビット幅を持つビットフィールドで使用できる" do
      expect {
        build_bit_fields([
          [nil, "register_0" , "0x00", nil, nil, nil, "bit_field_0_0" , "[0]"   , "rwl", '0', "bit_field_12_0"],
          [nil, "register_1" , "0x04", nil, nil, nil, "bit_field_1_0" , "[1:0]" , "rwl", '0', "bit_field_12_0"],
          [nil, "register_2" , "0x08", nil, nil, nil, "bit_field_2_0" , "[3:0]" , "rwl", '0', "bit_field_12_0"],
          [nil, "register_3" , "0x0C", nil, nil, nil, "bit_field_3_0" , "[7:0]" , "rwl", '0', "bit_field_12_0"],
          [nil, "register_4" , "0x10", nil, nil, nil, "bit_field_4_0" , "[15:0]", "rwl", '0', "bit_field_12_0"],
          [nil, "register_5" , "0x14", nil, nil, nil, "bit_field_5_0" , "[31:0]", "rwl", '0', "bit_field_12_0"],
          [nil, "register_6" , "0x20", nil, nil, nil, "bit_field_6_0" , "[0]"   , "rwe", '0', "bit_field_12_1"],
          [nil, "register_7" , "0x24", nil, nil, nil, "bit_field_7_0" , "[1:0]" , "rwe", '0', "bit_field_12_1"],
          [nil, "register_8" , "0x28", nil, nil, nil, "bit_field_8_0" , "[3:0]" , "rwe", '0', "bit_field_12_1"],
          [nil, "register_9" , "0x2C", nil, nil, nil, "bit_field_9_0" , "[7:0]" , "rwe", '0', "bit_field_12_1"],
          [nil, "register_10", "0x30", nil, nil, nil, "bit_field_10_0", "[15:0]", "rwe", '0', "bit_field_12_1"],
          [nil, "register_11", "0x34", nil, nil, nil, "bit_field_11_0", "[31:0]", "rwe", '0', "bit_field_12_1"],
          [nil, "register_12", "0x40", nil, nil, nil, "bit_field_12_0", "[0]"   , "rw" , '0', nil             ],
          [nil, nil          , nil   , nil, nil, nil, "bit_field_12_1", "[1]"   , "rw" , '0', nil             ]
        ])
      }.not_to raise_error
    end

    it "初期値を必要とする" do
      expect {
        build_bit_fields([
          [nil, "register_0", "0x00", nil, nil, nil, "bit_field_0_0", "[0]", "rwl", nil, "bit_field_1_0"],
          [nil, "register_1", "0x04", nil, nil, nil, "bit_field_1_0", "[0]", "rw" , '0', nil            ]
        ])
      }.to raise_error RgGen::RegisterMapError
      expect {
        build_bit_fields([
          [nil, "register_0", "0x00", nil, nil, nil, "bit_field_0_0", "[0]", "rwe", nil, "bit_field_1_0"],
          [nil, "register_1", "0x04", nil, nil, nil, "bit_field_1_0", "[0]", "rw" , '0', nil            ]
        ])
      }.to raise_error RgGen::RegisterMapError
    end

    it "1ビットの参照ビットフィールドを必要とする" do
      expect {
        build_bit_fields([
          [nil, "register_0", "0x00", nil, nil, nil, "bit_field_0_0", "[0]", "rwl", '0', nil]
        ])
      }.to raise_error RgGen::RegisterMapError
      expect {
        build_bit_fields([
          [nil, "register_0", "0x00", nil, nil, nil, "bit_field_0_0", "[0]"  , "rwl", '0', "bit_field_1_0"],
          [nil, "register_1", "0x04", nil, nil, nil, "bit_field_1_0", "[1:0]", "rw" , '0', nil            ]
        ])
      }.to raise_error RgGen::RegisterMapError
      expect {
        build_bit_fields([
          [nil, "register_0", "0x00", nil, nil, nil, "bit_field_0_0", "[0]", "rwe", '0', nil]
        ])
      }.to raise_error RgGen::RegisterMapError
      expect {
        build_bit_fields([
          [nil, "register_0", "0x00", nil, nil, nil, "bit_field_0_0", "[0]"  , "rwe", '0', "bit_field_1_0"],
          [nil, "register_1", "0x04", nil, nil, nil, "bit_field_1_0", "[1:0]", "rw" , '0', nil            ]
        ])
      }.to raise_error RgGen::RegisterMapError
    end
  end

  describe "rtl" do
    before(:all) do
      register_map  = create_register_map(
        @configuration,
        "block_0" => [
          [nil, nil         , "block_0"                                                                                                               ],
          [nil, nil         , 256                                                                                                                     ],
          [nil, nil         , nil                                                                                                                     ],
          [nil, nil         , nil                                                                                                                     ],
          [nil, "register_0", "0x00"     , nil     , nil                           , nil, "bit_field_0_0", "[31:16]", "rwl", "0x0123", "bit_field_6_0"],
          [nil, nil         , nil        , nil     , nil                           , nil, "bit_field_0_1", "[0]"    , "rwl", "0x0"   , "bit_field_6_0"],
          [nil, "register_1", "0x04-0x0B", "[2]"   , nil                           , nil, "bit_field_1_0", "[0]"    , "rwl", "0x0"   , "bit_field_6_0"],
          [nil, "register_2", "0x0C"     , "[2, 2]", "bit_field_7_0, bit_field_7_1", nil, "bit_field_2_0", "[0]"    , "rwl", "0x0"   , "bit_field_6_0"],
          [nil, "register_3", "0x10"     , nil     , nil                           , nil, "bit_field_3_0", "[31:16]", "rwe", "0x4567", "bit_field_6_1"],
          [nil, nil         , nil        , nil     , nil                           , nil, "bit_field_3_1", "[0]"    , "rwe", "0x0"   , "bit_field_6_1"],
          [nil, "register_4", "0x14-0x1B", "[2]"   , nil                           , nil, "bit_field_4_0", "[0]"    , "rwe", "0x0"   , "bit_field_6_1"],
          [nil, "register_5", "0x1C"     , "[2, 2]", "bit_field_7_0, bit_field_7_1", nil, "bit_field_5_0", "[0]"    , "rwe", "0x0"   , "bit_field_6_1"],
          [nil, "register_6", "0x20"     , nil     , nil                           , nil, "bit_field_6_0", "[1]"    , "rw" , "0x0"   , nil            ],
          [nil, nil         , nil        , nil     , nil                           , nil, "bit_field_6_1", "[0]"    , "rw" , "0x0"   , nil            ],
          [nil, "register_7", "0x24"     , nil     , nil                           , nil, "bit_field_7_0", "[3:2]"  , "rw" , "0x0"   , nil            ],
          [nil, nil         , nil        , nil     , nil                           , nil, "bit_field_7_1", "[1:0]"  , "rw" , "0x0"   , nil            ]
        ]
      )
      @rtl  = build_rtl_factory.create(@configuration, register_map).bit_fields
    end

    let(:rtl) do
      @rtl
    end

    it "出力ポートvalue_outを持つ" do
      expect(rtl[0]).to have_output :value_out, name: "o_bit_field_0_0", width: 16
      expect(rtl[1]).to have_output :value_out, name: "o_bit_field_0_1", width: 1
      expect(rtl[2]).to have_output :value_out, name: "o_bit_field_1_0", width: 1 , dimensions: [2]
      expect(rtl[3]).to have_output :value_out, name: "o_bit_field_2_0", width: 1 , dimensions: [2, 2]
      expect(rtl[4]).to have_output :value_out, name: "o_bit_field_3_0", width: 16
      expect(rtl[5]).to have_output :value_out, name: "o_bit_field_3_1", width: 1
      expect(rtl[6]).to have_output :value_out, name: "o_bit_field_4_0", width: 1 , dimensions: [2]
      expect(rtl[7]).to have_output :value_out, name: "o_bit_field_5_0", width: 1 , dimensions: [2, 2]
    end

    describe "#generate_code" do
      let(:expected_code_0) do
        <<'CODE'
assign o_bit_field_0_0 = bit_field_0_0_value;
rggen_bit_field_rwl_rwe #(
  .LOCK_MODE      (1),
  .WIDTH          (16),
  .INITIAL_VALUE  (16'h0123)
) u_bit_field_0_0 (
  .clk              (clk),
  .rst_n            (rst_n),
  .i_lock_or_enable (bit_field_6_0_value),
  .i_command_valid  (command_valid),
  .i_select         (register_select[0]),
  .i_write          (write),
  .i_write_data     (write_data[31:16]),
  .i_write_mask     (write_mask[31:16]),
  .o_value          (bit_field_0_0_value)
);
CODE
      end

      let(:expected_code_1) do
        <<'CODE'
assign o_bit_field_0_1 = bit_field_0_1_value;
rggen_bit_field_rwl_rwe #(
  .LOCK_MODE      (1),
  .WIDTH          (1),
  .INITIAL_VALUE  (1'h0)
) u_bit_field_0_1 (
  .clk              (clk),
  .rst_n            (rst_n),
  .i_lock_or_enable (bit_field_6_0_value),
  .i_command_valid  (command_valid),
  .i_select         (register_select[0]),
  .i_write          (write),
  .i_write_data     (write_data[0]),
  .i_write_mask     (write_mask[0]),
  .o_value          (bit_field_0_1_value)
);
CODE
      end

      let(:expected_code_2) do
        <<'CODE'
assign o_bit_field_1_0[g_i] = bit_field_1_0_value[g_i];
rggen_bit_field_rwl_rwe #(
  .LOCK_MODE      (1),
  .WIDTH          (1),
  .INITIAL_VALUE  (1'h0)
) u_bit_field_1_0 (
  .clk              (clk),
  .rst_n            (rst_n),
  .i_lock_or_enable (bit_field_6_0_value),
  .i_command_valid  (command_valid),
  .i_select         (register_select[1+g_i]),
  .i_write          (write),
  .i_write_data     (write_data[0]),
  .i_write_mask     (write_mask[0]),
  .o_value          (bit_field_1_0_value[g_i])
);
CODE
      end

      let(:expected_code_3) do
        <<'CODE'
assign o_bit_field_2_0[g_i][g_j] = bit_field_2_0_value[g_i][g_j];
rggen_bit_field_rwl_rwe #(
  .LOCK_MODE      (1),
  .WIDTH          (1),
  .INITIAL_VALUE  (1'h0)
) u_bit_field_2_0 (
  .clk              (clk),
  .rst_n            (rst_n),
  .i_lock_or_enable (bit_field_6_0_value),
  .i_command_valid  (command_valid),
  .i_select         (register_select[3+2*g_i+g_j]),
  .i_write          (write),
  .i_write_data     (write_data[0]),
  .i_write_mask     (write_mask[0]),
  .o_value          (bit_field_2_0_value[g_i][g_j])
);
CODE
      end

      let(:expected_code_4) do
        <<'CODE'
assign o_bit_field_3_0 = bit_field_3_0_value;
rggen_bit_field_rwl_rwe #(
  .LOCK_MODE      (0),
  .WIDTH          (16),
  .INITIAL_VALUE  (16'h4567)
) u_bit_field_3_0 (
  .clk              (clk),
  .rst_n            (rst_n),
  .i_lock_or_enable (bit_field_6_1_value),
  .i_command_valid  (command_valid),
  .i_select         (register_select[7]),
  .i_write          (write),
  .i_write_data     (write_data[31:16]),
  .i_write_mask     (write_mask[31:16]),
  .o_value          (bit_field_3_0_value)
);
CODE
      end

      let(:expected_code_5) do
        <<'CODE'
assign o_bit_field_3_1 = bit_field_3_1_value;
rggen_bit_field_rwl_rwe #(
  .LOCK_MODE      (0),
  .WIDTH          (1),
  .INITIAL_VALUE  (1'h0)
) u_bit_field_3_1 (
  .clk              (clk),
  .rst_n            (rst_n),
  .i_lock_or_enable (bit_field_6_1_value),
  .i_command_valid  (command_valid),
  .i_select         (register_select[7]),
  .i_write          (write),
  .i_write_data     (write_data[0]),
  .i_write_mask     (write_mask[0]),
  .o_value          (bit_field_3_1_value)
);
CODE
      end

      let(:expected_code_6) do
        <<'CODE'
assign o_bit_field_4_0[g_i] = bit_field_4_0_value[g_i];
rggen_bit_field_rwl_rwe #(
  .LOCK_MODE      (0),
  .WIDTH          (1),
  .INITIAL_VALUE  (1'h0)
) u_bit_field_4_0 (
  .clk              (clk),
  .rst_n            (rst_n),
  .i_lock_or_enable (bit_field_6_1_value),
  .i_command_valid  (command_valid),
  .i_select         (register_select[8+g_i]),
  .i_write          (write),
  .i_write_data     (write_data[0]),
  .i_write_mask     (write_mask[0]),
  .o_value          (bit_field_4_0_value[g_i])
);
CODE
      end

      let(:expected_code_7) do
        <<'CODE'
assign o_bit_field_5_0[g_i][g_j] = bit_field_5_0_value[g_i][g_j];
rggen_bit_field_rwl_rwe #(
  .LOCK_MODE      (0),
  .WIDTH          (1),
  .INITIAL_VALUE  (1'h0)
) u_bit_field_5_0 (
  .clk              (clk),
  .rst_n            (rst_n),
  .i_lock_or_enable (bit_field_6_1_value),
  .i_command_valid  (command_valid),
  .i_select         (register_select[10+2*g_i+g_j]),
  .i_write          (write),
  .i_write_data     (write_data[0]),
  .i_write_mask     (write_mask[0]),
  .o_value          (bit_field_5_0_value[g_i][g_j])
);
CODE
      end

      it "RWL/RWEビットフィールドモジュールをインスタンスするコードを生成する" do
        expect(rtl[0]).to generate_code :module_item, :top_down, expected_code_0
        expect(rtl[1]).to generate_code :module_item, :top_down, expected_code_1
        expect(rtl[2]).to generate_code :module_item, :top_down, expected_code_2
        expect(rtl[3]).to generate_code :module_item, :top_down, expected_code_3
        expect(rtl[4]).to generate_code :module_item, :top_down, expected_code_4
        expect(rtl[5]).to generate_code :module_item, :top_down, expected_code_5
        expect(rtl[6]).to generate_code :module_item, :top_down, expected_code_6
        expect(rtl[7]).to generate_code :module_item, :top_down, expected_code_7
      end
    end
  end

  describe "ral" do
    before(:all) do
      register_map  = create_register_map(
        @configuration,
        "block_0" => [
          [nil, nil         , "block_0"                                                                   ],
          [nil, nil         , 256                                                                         ],
          [nil, nil         , nil                                                                         ],
          [nil, nil         , nil                                                                         ],
          [nil, "register_0", "0x00", nil, nil, nil, "bit_field_0_0", "[0]", "rwl", "0x0", "bit_field_2_0"],
          [nil, "register_1", "0x04", nil, nil, nil, "bit_field_1_0", "[0]", "rwe", "0x0", "bit_field_3_0"],
          [nil, "register_2", "0x08", nil, nil, nil, "bit_field_2_0", "[0]", "rw" , "0x0", nil            ],
          [nil, "register_3", "0x0C", nil, nil, nil, "bit_field_3_0", "[0]", "rw" , "0x0", nil            ]
        ]
      )
      @ral  = build_ral_factory.create(@configuration, register_map).bit_fields
    end

    let(:ral) do
      @ral
    end

    describe "#model_name" do
      it "WRL/RWE用のモデル名を返す" do
        expect(ral[0].model_name).to eq 'rggen_ral_field_rwl#("register_2", "bit_field_2_0")'
        expect(ral[1].model_name).to eq 'rggen_ral_field_rwe#("register_3", "bit_field_3_0")'
      end
    end
  end
end