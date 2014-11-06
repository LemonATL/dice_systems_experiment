require './array'
require './die'
require './roll'

# The Shadowrunlike rules allow for an arbitrary number of six-sided dice to be
# rolled. Each die showing a '5' or a '6' is considered a success. In addition, 
# each '6' also adds another die to the roll. 

module Shadowrun
  class Die < ::Die
    DEFAULT_SUCCESS_THRESHOLD   = 5
    DEFAULT_EXPLOSION_THRESHOLD = 6

    def initialize(opts={})
      super(opts)
      @success_threshold    = opts[:success_threshold]   || DEFAULT_SUCCESS_THRESHOLD
      @explosion_threshold  = opts[:explosion_threshold] || DEFAULT_EXPLOSION_THRESHOLD
    end

    def value
      @value ||= if face >= @explosion_threshold
        1 + self.class.new(@opts).value
      elsif face >= @success_threshold
        1
      else
        0
      end
    end
  end

  class Roll < ::Roll
    def successes
      @successes ||= @dice.times.map { Die.new(@die_opts).value }.sum
    end
  end
end
