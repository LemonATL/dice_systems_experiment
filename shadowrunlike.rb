require './array'

# The Shadowrunlike rules allow for an arbitrary number of six-sided dice to be
# rolled. Each die showing a '5' or a '6' is considered a success. In addition, 
# each '6' also adds another die to the roll. 

module Shadowrunlike
  class Die
    DEFAULT_SIDES               = 6
    DEFAULT_SUCCESS_THRESHOLD   = 5
    DEFAULT_EXPLOSION_THRESHOLD = 6

    def initialize(opts={})
      @opts = opts.frozen? ? opts : opts.dup.freeze

      @sides                = opts[:sides]               || DEFAULT_SIDES
      @success_threshold    = opts[:success_threshold]   || DEFAULT_SUCCESS_THRESHOLD
      @explosion_threshold  = opts[:explosion_threshold] || DEFAULT_EXPLOSION_THRESHOLD
    end

    def face
      @face ||= rand(@sides) + 1
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

  class Roll
    DEFAULT_DICE = 5

    def initialize(opts={})
      @opts = opts.frozen? ? opts : opts.dup.freeze

      @dice     = opts[:dice] || DEFAULT_DICE
      @die_opts = opts[:die]  || {}
    end

    def successes
      @successes ||= @dice.times.map { Die.new(@die_opts).value }.sum
    end
  end
end
