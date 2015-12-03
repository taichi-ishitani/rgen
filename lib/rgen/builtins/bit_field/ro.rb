RGen.list_item(:bit_field, :type, :ro) do
  register_map do
    read_only
  end

  rtl do
    build do
      input :value_in, name: "i_#{source.name}", width: source.width
    end

    generate_code(:module_item) do |buffer|
      buffer << assign(value, value_in) << "\n"
    end
  end
end
