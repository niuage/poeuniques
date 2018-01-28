class Mod < ApplicationRecord
  attr_accessor :hidden, :values

  def self.parse(text_mod)
    text_mod.squish!

    if text_mod.match /\(hidden\)/i
      text_mod.gsub!(/ \(Hidden\)/i, "")
    end


  end
end
