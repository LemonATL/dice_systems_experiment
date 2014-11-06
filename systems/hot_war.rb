require './array'
require './die'
require './roll'

# In Hot War, each side of a challenge resolved with dice has a pool of dice. 
# The highest roll wins. The number of dice with defeat the opposing roll 
# determines the degree of success. 
#
# In this (slightly modified) version, 5's and 6's count as 5's and explode. 
# Additionally, it is possible to roll against a fixed target number. 

module HotWar
  class Die < ::Die
    DEFAULT_EXPLOSION_VALUE     = 5
    DEFAULT_EXPLOSION_THRESHOLD = 5

    def initialize(opts={})
      super(opts)
      @explosion_value      = opts[:explosion_value]      || DEFAULT_EXPLOSION_VALUE
      @explosion_threshold  = opts[:explosion_threshold]  || DEFAULT_EXPLOSION_THRESHOLD
    end

    def value
      @value ||= face >= @explosion_threshold ? (@explosion_value + Die.new(@opts).value) : face
    end
  end

  class Roll < ::Roll
    DEFAULT_TARGET_NUMBER   = 5

    def values
      @values ||= @dice.times.map { Die.new(@die_opts).value }.sort
    end

    def max
      @max ||= values.last
    end

    def successes(vs=DEFAULT_TARGET_NUMBER)
      if vs.is_a? Roll
        vs_roll_successes(vs)
      elsif vs.is_a? Integer
        vs_target_number_successes(vs)
      end
    end
    alias_method :vs, :successes

    private

    def vs_roll_successes(roll)
      if self.max == roll.max
        0
      elsif self.max > roll.max
        vs_target_number_successes(roll.max)
      else
        -roll.successes(self)
      end
    end

    def vs_target_number_successes(target_number)
      values.count {|i| i > target_number}
    end
  end
end
