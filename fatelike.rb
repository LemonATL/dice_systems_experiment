require './array'

# In Fate, four six-sided dice are rolled, with two sides marked '-', two sides 
# marked '*', and two sides marked '+'. Each '-' results in -1 to the roll, each 
# '+' results in +1 to the roll, and each '*' is ignored. 

# The Fatelike roller allows for an arbitrary number of dice to be rolled, with 
# (by default) one side marked '-' and one side marked '+'. In addition, another
# side is marked '++', which means "success, plus a bonus die." A bonus die is 
# is just like a typical die, but failures on this die are ignored. 

module Fatelike
  class Die
    DEFAULT_SIDES             = 6
    DEFAULT_FAILURE_THRESHOLD = 1
    DEFAULT_SUCCESS_THRESHOLD = 5
    DEFAULT_BONUS_THRESHOLD   = 6

    def initialize(opts={})
      @opts  = opts.dup

      @sides              = @opts[:sides]              || DEFAULT_SIDES
      @failure_threshold  = @opts[:failure_threshold]  || DEFAULT_FAILURE_THRESHOLD
      @success_threshold  = @opts[:success_threshold]  || DEFAULT_SUCCESS_THRESHOLD
      @bonus_threshold    = @opts[:bonus_threshold]    || DEFAULT_BONUS_THRESHOLD
      @bonus              = !!@opts[:bonus]
    end

    def face 
      @face ||= rand(@sides) + 1
    end

    def value
      @value ||= if face <= @failure_threshold && !bonus?
        -1
      elsif face >= @bonus_threshold
        1 + self.class.new(@opts.merge({bonus:true})).value
      elsif face >= @success_threshold
        1
      else
        0
      end
    end

    def bonus?
      @bonus
    end
  end

  class Roll
    DEFAULT_DICE = 5

    def initialize(opts={})
      @opts     = opts.frozen? ? opts : opts.dup.freeze

      @dice     = @opts[:dice] || DEFAULT_DICE
      @die_opts = @opts[:die]  || {}
    end

    def successes
      @total ||= @dice.times.map { Die.new(@die_opts).value }.sum
    end
  end

end
