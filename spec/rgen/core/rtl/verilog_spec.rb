require_relative '../../../spec_helper'

module RGen::Rtl
  describe Verilog do
    let(:verilog) do
      Class.new {
        include Verilog
      }.new
    end

    describe "#wire" do
      it "Identifierオブジェクトを生成し、与えたハンドル名でアクセッサを定義する" do
        verilog.instance_eval {wire :foo}
        expect(verilog.foo     ).to be_instance_of Verilog::Identifier
        expect(verilog.foo.to_s).to eq 'foo'
      end

      it "#identifiersに与えたハンドル名を追加する" do
        verilog.instance_eval {wire :foo}
        expect(verilog.identifiers.last).to eq :foo
      end

      it "#typeが:wireのSignalDeclarationオブジェクトを生成し、#signal_declarationsに追加する" do
        verilog.instance_eval {wire :foo}
        expect(verilog.signal_declarations.last     ).to be_instance_of Verilog::SignalDeclaration
        expect(verilog.signal_declarations.last.type).to eq :wire
        expect(verilog.signal_declarations.last.name).to eq 'foo'
      end

      specify "与えた属性は生成するSignalDeclarationオブジェクトに反映される" do
        verilog.instance_eval {wire :foo, width:2, dimension:4}
        expect(verilog.signal_declarations.last.width    ).to eq '[1:0]'
        expect(verilog.signal_declarations.last.dimension).to eq '[4]'
      end

      context "属性で信号名を与えた場合" do
        specify "与えた信号名が反映される" do
          verilog.instance_eval {wire :foo, name:"w_foo"}
          expect(verilog.foo.to_s                     ).to eq "w_foo"
          expect(verilog.signal_declarations.last.name).to eq "w_foo"
        end
      end
    end

    describe "#reg" do
      it "Identifierオブジェクトを生成し、与えたハンドル名でアクセッサを定義する" do
        verilog.instance_eval {reg :foo}
        expect(verilog.foo     ).to be_instance_of Verilog::Identifier
        expect(verilog.foo.to_s).to eq 'foo'
      end

      it "#identifiersに与えたハンドル名を追加する" do
        verilog.instance_eval {reg :foo}
        expect(verilog.identifiers.last).to eq :foo
      end

      it "#typeが:regのSignalDeclarationオブジェクトを生成し、#signal_declarationsに追加する" do
        verilog.instance_eval {reg :foo}
        expect(verilog.signal_declarations.last     ).to be_instance_of Verilog::SignalDeclaration
        expect(verilog.signal_declarations.last.type).to eq :reg
        expect(verilog.signal_declarations.last.name).to eq 'foo'
      end

      specify "与えた属性は生成するSignalDeclarationオブジェクトに反映される" do
        verilog.instance_eval {reg :foo, width:2, dimension:4}
        expect(verilog.signal_declarations.last.width    ).to eq '[1:0]'
        expect(verilog.signal_declarations.last.dimension).to eq '[4]'
      end

      context "属性で信号名を与えた場合" do
        specify "与えた信号名が反映される" do
          verilog.instance_eval {reg :foo, name:"r_foo"}
          expect(verilog.foo.to_s                     ).to eq "r_foo"
          expect(verilog.signal_declarations.last.name).to eq "r_foo"
        end
      end
    end

    describe "#logic" do
      it "Identifierオブジェクトを生成し、与えたハンドル名でアクセッサを定義する" do
        verilog.instance_eval {logic :foo}
        expect(verilog.foo     ).to be_instance_of Verilog::Identifier
        expect(verilog.foo.to_s).to eq 'foo'
      end

      it "#identifiersに与えたハンドル名を追加する" do
        verilog.instance_eval {logic :foo}
        expect(verilog.identifiers.last).to eq :foo
      end

      it "#typeが:logicのSignalDeclarationオブジェクトを生成し、#signal_declarationsに追加する" do
        verilog.instance_eval {logic :foo}
        expect(verilog.signal_declarations.last     ).to be_instance_of Verilog::SignalDeclaration
        expect(verilog.signal_declarations.last.type).to eq :logic
        expect(verilog.signal_declarations.last.name).to eq 'foo'
      end

      specify "与えた属性は生成するSignalDeclarationオブジェクトに反映される" do
        verilog.instance_eval {logic :foo, width:2, dimension:4}
        expect(verilog.signal_declarations.last.width    ).to eq '[1:0]'
        expect(verilog.signal_declarations.last.dimension).to eq '[4]'
      end

      context "属性で信号名を与えた場合" do
        specify "与えた信号名が反映される" do
          verilog.instance_eval {logic :foo, name:"l_foo"}
          expect(verilog.foo.to_s                     ).to eq "l_foo"
          expect(verilog.signal_declarations.last.name).to eq "l_foo"
        end
      end
    end

    describe "#input" do
      it "Identifierオブジェクトを生成し、与えたハンドル名でアクセッサを定義する" do
        verilog.instance_eval {input :foo}
        expect(verilog.foo     ).to be_instance_of Verilog::Identifier
        expect(verilog.foo.to_s).to eq 'foo'
      end

      it "#identifiersに与えたハンドル名を追加する" do
        verilog.instance_eval {input :foo}
        expect(verilog.identifiers.last).to eq :foo
      end

      it "#directionが:inputのPortDeclarationオブジェクトを生成し、#port_declarationsに追加する" do
        verilog.instance_eval {input :foo}
        expect(verilog.port_declarations.last          ).to be_instance_of Verilog::PortDeclaration
        expect(verilog.port_declarations.last.direction).to eq :input
        expect(verilog.port_declarations.last.name     ).to eq 'foo'
      end

      specify "与えた属性は生成するPortDeclarationオブジェクトに反映される" do
        verilog.instance_eval {input :foo, type: :logic, width:2, dimension:4}
        expect(verilog.port_declarations.last.type     ).to eq :logic
        expect(verilog.port_declarations.last.width    ).to eq '[1:0]'
        expect(verilog.port_declarations.last.dimension).to eq '[4]'
      end

      context "属性でポート名を与えた場合" do
        specify "与えたポート名が反映される" do
          verilog.instance_eval {input :foo, name:"i_foo"}
          expect(verilog.foo.to_s                   ).to eq "i_foo"
          expect(verilog.port_declarations.last.name).to eq "i_foo"
        end
      end
    end

    describe "#output" do
      it "Identifierオブジェクトを生成し、与えたハンドル名でアクセッサを定義する" do
        verilog.instance_eval {output :foo}
        expect(verilog.foo     ).to be_instance_of Verilog::Identifier
        expect(verilog.foo.to_s).to eq 'foo'
      end

      it "#identifiersに与えたハンドル名を追加する" do
        verilog.instance_eval {output :foo}
        expect(verilog.identifiers.last).to eq :foo
      end

      it "#directionが:outputのPortDeclarationオブジェクトを生成し、#port_declarationsに追加する" do
        verilog.instance_eval {output :foo}
        expect(verilog.port_declarations.last          ).to be_instance_of Verilog::PortDeclaration
        expect(verilog.port_declarations.last.direction).to eq :output
        expect(verilog.port_declarations.last.name     ).to eq 'foo'
      end

      specify "与えた属性は生成するPortDeclarationオブジェクトに反映される" do
        verilog.instance_eval {output :foo, type: :logic, width:2, dimension:4}
        expect(verilog.port_declarations.last.type     ).to eq :logic
        expect(verilog.port_declarations.last.width    ).to eq '[1:0]'
        expect(verilog.port_declarations.last.dimension).to eq '[4]'
      end

      context "属性でポート名を与えた場合" do
        specify "与えたポート名が反映される" do
          verilog.instance_eval {output :foo, name:"o_foo"}
          expect(verilog.foo.to_s                   ).to eq "o_foo"
          expect(verilog.port_declarations.last.name).to eq "o_foo"
        end
      end
    end

    describe "#parameter" do
      it "Identifierオブジェクトを生成し、与えたハンドル名でアクセッサを定義する" do
        verilog.instance_eval {parameter :foo}
        expect(verilog.foo     ).to be_instance_of Verilog::Identifier
        expect(verilog.foo.to_s).to eq 'foo'
      end

      it "#identifiersに与えたハンドル名を追加する" do
        verilog.instance_eval {parameter :foo}
        expect(verilog.identifiers.last).to eq :foo
      end

      it "#typeが:parameterのParameterDeclarationオブジェクトを生成し、#parameter_declarationsに追加する" do
        verilog.instance_eval {parameter :foo}
        expect(verilog.parameter_declarations.last     ).to be_instance_of Verilog::ParameterDeclaration
        expect(verilog.parameter_declarations.last.type).to eq :parameter
        expect(verilog.parameter_declarations.last.name).to eq 'foo'
      end

      specify "与えた属性は生成するParameterDeclarationオブジェクトに反映される" do
        verilog.instance_eval {parameter :foo, default_value: 1}
        expect(verilog.parameter_declarations.last.default_value).to eq 1
      end

      context "属性でパラメータ名を与えた場合" do
        specify "与えたパラメータ名が反映される" do
          verilog.instance_eval {parameter :foo, name:"FOO"}
          expect(verilog.foo.to_s                        ).to eq "FOO"
          expect(verilog.parameter_declarations.last.name).to eq "FOO"
        end
      end
    end

    describe "#localparam" do
      it "Identifierオブジェクトを生成し、与えたハンドル名でアクセッサを定義する" do
        verilog.instance_eval {localparam :foo}
        expect(verilog.foo     ).to be_instance_of Verilog::Identifier
        expect(verilog.foo.to_s).to eq 'foo'
      end

      it "#identifiersに与えたハンドル名を追加する" do
        verilog.instance_eval {localparam :foo}
        expect(verilog.identifiers.last).to eq :foo
      end

      it "#typeが:localparamのParameterDeclarationオブジェクトを生成し、#localparam_declarationsに追加する" do
        verilog.instance_eval {localparam :foo}
        expect(verilog.localparam_declarations.last     ).to be_instance_of Verilog::ParameterDeclaration
        expect(verilog.localparam_declarations.last.type).to eq :localparam
        expect(verilog.localparam_declarations.last.name).to eq 'foo'
      end

      specify "与えた属性は生成するParameterDeclarationオブジェクトに反映される" do
        verilog.instance_eval {localparam :foo, default_value: 1}
        expect(verilog.localparam_declarations.last.default_value).to eq 1
      end

      context "属性でパラメータ名を与えた場合" do
        specify "与えたパラメータ名が反映される" do
          verilog.instance_eval {localparam :foo, name:"FOO"}
          expect(verilog.foo.to_s                         ).to eq "FOO"
          expect(verilog.localparam_declarations.last.name).to eq "FOO"
        end
      end
    end

    describe "#group" do
      before do
        verilog.instance_eval do
          group(:foo_bar_baz) do
            wire  :foo
            reg   :bar
            logic :baz
          end
          group(:qux_quux) do
            input  :qux
            output :quux
          end
          group(:FOO_BAR) do
            parameter :FOO
            parameter :BAR
          end
          group(:BAZ_QUX) do
            localparam :BAZ
            localparam :QUX
          end
        end
      end

      it "ブロック内で定義した信号、ポート、パラメータをまとめるグループオブジェクトを生成する" do
        expect(verilog.foo_bar_baz.foo.to_s).to eq "foo"
        expect(verilog.foo_bar_baz.bar.to_s).to eq "bar"
        expect(verilog.foo_bar_baz.baz.to_s).to eq "baz"
        expect(verilog.qux_quux.qux.to_s   ).to eq "qux"
        expect(verilog.qux_quux.quux.to_s  ).to eq "quux"
        expect(verilog.FOO_BAR.FOO.to_s    ).to eq "FOO"
        expect(verilog.FOO_BAR.BAR.to_s    ).to eq "BAR"
        expect(verilog.BAZ_QUX.BAZ.to_s    ).to eq "BAZ"
        expect(verilog.BAZ_QUX.QUX.to_s    ).to eq "QUX"
      end

      it "与えたグループ名を#identifiersに追加する" do
        expect(verilog.identifiers).to match [:foo_bar_baz, :qux_quux, :FOO_BAR, :BAZ_QUX]
      end

      specify "group内で定義された識別子名は#identifiresに追加されない" do
        expect(verilog.identifiers).not_to include(:foo, :bar, :baz, :qux, :quux, :FOO, :BAR, :BAZ, :QUX)
      end

      specify "#groupを抜けた後は、それぞれの定義メソッドは通常の動作をする" do
        verilog.instance_eval do
          wire       :foo
          reg        :bar
          logic      :baz
          input      :qux
          output     :quux
          parameter  :FOO
          parameter  :BAR
          localparam :BAZ
          localparam :QUX
        end
        expect(verilog.identifiers).to match [:foo_bar_baz, :qux_quux, :FOO_BAR, :BAZ_QUX, :foo, :bar, :baz, :qux, :quux, :FOO, :BAR, :BAZ, :QUX]
      end
    end

    describe "#assign" do
      let(:lhs) do
        Verilog::Identifier.new('foo')
      end

      let(:rhs_list) do
        ["4'b0000", Verilog::Identifier.new('bar')]
      end

      it "継続代入のコード片を返す" do
        expect(verilog.send(:assign, lhs,      rhs_list[0])).to eq "assign foo = 4'b0000;"
        expect(verilog.send(:assign, lhs[1,0], rhs_list[1])).to eq "assign foo[1:0] = bar;"
      end
    end

    describe "#concat" do
      let(:expressions) do
        ["4'b0000", Verilog::Identifier.new('foo'), Verilog::Identifier.new('bar')]
      end

      it "連接のコード片を返す" do
        expect(verilog.send(:concat, *expressions  )).to eq "{4'b0000, foo, bar}"
        expect(verilog.send(:concat, expressions[0])).to eq "{4'b0000}"
      end
    end

    describe "#bin" do
      it "与えた値をVerilog形式の2進数表記に変換する" do
        expect(verilog.send(:bin, 2, 2)).to eq "2'b10"
        expect(verilog.send(:bin, 2, 3)).to eq "3'b010"
      end
    end

    describe "#dec" do
      it "与えた値をVerilog形式の10進数表記に変換する" do
        expect(verilog.send(:dec, 8, 4)).to eq "4'd8"
      end
    end

    describe "#hex" do
      it "与えた値をVerilog形式の16進数表記に変換する" do
        expect(verilog.send(:hex, 0x1f, 7)).to eq "7'h1f"
        expect(verilog.send(:hex, 0x1f, 8)).to eq "8'h1f"
        expect(verilog.send(:hex, 0x1f, 9)).to eq "9'h01f"
      end
    end
  end
end
