class String
  
  # i don't really understand why this was be removed from String
  #   see https://github.com/mruby/mruby/commit/ff08856fe314faa4d16b4502c0960a3475387846
  # i am hoping readding this will not break anything
  def to_str
    to_s
  end

end