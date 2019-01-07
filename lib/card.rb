# frozen_string_literal: true

class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def self.parse(str)
    split_str = str.chars

    rank = RANK.key(split_str[0])
    suit = split_str[1]

    new(rank, suit)
  end

  def to_s
    RANK[rank] + suit
  end
end
