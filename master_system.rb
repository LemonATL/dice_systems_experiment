require './array'

# The MasterSystem rules are similar to the SquareSystem rules, in that die 
# rolls are summed, there are explosions, and a table is used to determine the 
# degree of success. 
# 
# The sum of the dice in a dice roll is looked up in the following table:
# |     SUM    | SUCC | 
# |          1 |    1 | 
# |          2 |    2 | 
# |    3 -   4 |    3 | 
# |    5 -   7 |    4 | 
# |    8 -  12 |    5 | 
# |   13 -  20 |    6 | 
# |   21 -  33 |    7 | 
# |   34 -  54 |    8 | 
# |   55 -  88 |    9 | 
# |   89 - 143 |   10 |
# |  144 - 232 |   11 | 
# ...etc.

module MasterSystem
  class Table
    def self.[](s)
      @table ||= {1 => 1, 2 => 2}

      until @table.keys.max >= s
        max = @table.keys.max
        @table[max + 1] = @table[max] + @table[max-1]
      end

      @table[s]
    end

    def self.successes_for(total)
      i = 1
      i += 1 until self[i] > total
      i - 1
    end
  end

  class Die
    DEFAULT_SIDES               = 6
    DEFAULT_EXPLOSION_VALUE     = 5
    DEFAULT_EXPLOSION_THRESHOLD = 5

    def initialize(opts={})
      @opts = opts.frozen? ? opts : opts.dup.freeze

      @sides                = opts[:sides]                || DEFAULT_SIDES
      @explosion_value      = opts[:success_threshold]    || DEFAULT_EXPLOSION_VALUE
      @explosion_threshold  = opts[:explosion_threshold]  || DEFAULT_EXPLOSION_THRESHOLD
    end

    def face
      @face ||= rand(@sides) + 1
    end

    def value
      @value ||= face >= @explosion_threshold ? (@explosion_value + Die.new(@opts).value) : face
    end
  end

  class Roll
    DEFAULT_DICE = 5

    def initialize(opts={})
      @opts  = @opts.frozen? ? opts : opts.dup.freeze

      @dice     = opts[:dice] || DEFAULT_DICE
      @die_opts = opts[:die]  || {}
    end

    def total
      @total ||= @dice.times.map { Die.new(@die_opts).value }.sum
    end

    def successes
      @successes ||= Table.successes_for(total)
    end
  end
end

