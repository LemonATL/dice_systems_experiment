require './array'
require './die'
require './roll'

# The SquareSystem rules allow for an arbitrary number of six-sided dice to be 
# rolled. For each die showing a 1, 2, 3 or 4, the values are simply summed. For
# dice showing a '5' or '6', the value is treated as 5, plus the result of an 
# additional die roll. 
#
# The sum of the dice is then looked up in the Square table, and a resultant
# number of successes is used to determine the degree of success. 
# 
#
# |     SUM    | SUCC | 
# |     1 -  2 |    1 | 
# |     3 -  5 |    2 | 
# |     6 -  9 |    3 | 
# |    10 - 14 |    4 | 
# |    15 - 20 |    5 | 
# |    21 - 27 |    6 | 
# |    28 - 35 |    7 | 
# |    36 - 44 |    8 | 
# |    45 - 54 |    9 | 
# |    55 - 65 |   10 | 
# |    66 - 78 |   11 | 
# ...etc

module Square
  class Table
    def self.[](i)
      @table ||= {1 => 1}

      if i > @table.keys.max
        (@table.keys.max + 1).upto(i) do |n|
          @table[n] = @table[n-1] + n
        end
      end

      @table[i]
    end

    def self.successes_for(total)
      i = 1
      i += 1 until self[i] > total
      i - 1
    end
  end

  class Die < ::Die
    DEFAULT_EXPLOSION_VALUE     = 5
    DEFAULT_EXPLOSION_THRESHOLD = 5

    def initialize(opts={})
      super(opts)
      @explosion_value      = opts[:success_threshold]    || DEFAULT_EXPLOSION_VALUE
      @explosion_threshold  = opts[:explosion_threshold]  || DEFAULT_EXPLOSION_THRESHOLD
    end

    def value
      @value ||= face >= @explosion_threshold ? (@explosion_value + Die.new(@opts).value) : face
    end
  end

  class Roll < ::Roll
    def total
      @total ||= @dice.times.map { Die.new(@die_opts).value }.sum
    end

    def successes
      @successes ||= Table.successes_for(total)
    end
  end
end
