class RGen::RegisterMap::BitField::BitField < RGen::InputBase::Component
  def register_map
    register.register_map
  end

  def register_block
    register.register_block
  end

  def register
    parent
  end
end
