class Hand
  attr_reader :cards

  include Comparable

  def initialize(cards)
    @cards = cards
  end

  def self.parse(str)
    arr = str.split(' ').map { |c| Card.parse(c) }

    if arr.length != 5
      fail "Wrong Length"
    end

    new(arr)
  end

  def <=>(other)
    result = rank_value <=> other.rank_value
    if result == 0
      result = value <=> other.value
    end
    result
  end

  def to_s
    cards.map(&:to_s).join(' ')
  end

  def rank_string
    HAND_RANK[rank][:str]
  end

  def rank_value
    HAND_RANK[rank][:value]
  end

  def value
    return [0, 0, 0, 0, 5, 4, 3, 2, 1] if wraparound_straight?

    four_rank = 0
    three_rank = 0
    pairs = []
    singles = []

    rank_sizes.each do |key, val|
      if val == 4
        four_rank = key
      elsif val == 3
        three_rank = key
      elsif val == 2
        pairs << key
      else
        singles << key
      end
    end

    pairs.sort!
    singles.sort!

    [
      four_rank,
      three_rank,
      pairs.fetch(1, 0),
      pairs.fetch(0, 0),
      singles.fetch(4, 0),
      singles.fetch(3, 0),
      singles.fetch(2, 0),
      singles.fetch(1, 0),
      singles.fetch(0, 0),
    ]
  end

  def rank
    if straight_flush?
      :straight_flush
    elsif four_of_a_kind?
      :four_of_a_kind
    elsif full_house?
      :full_house
    elsif flush?
      :flush
    elsif straight?
      :straight
    elsif three_of_a_kind?
      :three_of_a_kind
    elsif two_pair?
      :two_pair
    elsif pair?
      :pair
    else
      :high_card
    end
  end

  private

  def pair?
    rank_sets.length == 4
  end

  def two_pair?
    rank_sets.length == 3 && most_common_rank_size == 2
  end

  def three_of_a_kind?
    rank_sets.length == 3 && most_common_rank_size == 3
  end

  def straight?
    all_consecutive? || wraparound_straight?
  end

  def flush?
    all_same_suit?
  end

  def full_house?
    rank_sets.length == 2 && most_common_rank_size == 3
  end

  def four_of_a_kind?
    rank_sets.length == 2 && most_common_rank_size == 4
  end

  def straight_flush?
    straight? && flush?
  end

  def rank_sets
    ranks = cards.map { |c| c.rank }
    ranks.sort!
    ranks.uniq
  end

  def rank_sizes
    frequencies = Hash.new(0)
    cards.each do |c|
      frequencies[c.rank] += 1
    end
    frequencies
  end

  def most_common_rank_size
    rank_sizes.values.max
  end

  def wraparound_straight?
    ranks = rank_sets
    ranks.length == 5 && ranks[3] == 5 && ranks[4] == 14
  end

  def all_consecutive?
    ranks = rank_sets
    ranks.length == 5 && ranks[4] - ranks[0] == 4
  end

  def all_same_suit?
    cards.all? { |c| c.suit == cards.first.suit }
  end
end
