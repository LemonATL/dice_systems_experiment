require './array'
require './die'
require './roll'
require './systems/square'

# In the Three system, each roll is a roll of 3D6, vs either a target number or 
# an opposed roll. The degree of success is determined using the Square Table. 
# As with the Square system, 6's are treated as "5 plus an additional die."
#
# Each roll adds some modifier based on skills, attributes, and environmental
# factors. For instance, a damage roll for a melee weapon might receive a bonus
# if the weapon is wielded by a strong character. 
# 
# More dice are added in lieu of large bonuses. Each multiple of +3 adds an 
# additional die to the die pool and reduces the flat bonus by 3. So if, for
# instance, a roll would be 3D6 + 4, that roll instead becomes 4D6 + 1. This 
# rule works in reverse for penalties. 
# 
# To determine what to roll, use the following table:
#
# Mod |  Roll
# --- | -----
#  -3 | 2D6
#  -2 | 2D6+1
#  -1 | 2D6+2
#   0 | 3D6
#  +1 | 3D6+1
#  +2 | 3D6+2
#  +3 | 4D6
# ... | ...
#  +7 | 5D6+1
#  +8 | 5D6+2
#  +9 | 6D6

module Three
  class Die < ::Die
    DEFAULT_EXPLOSION_VALUE     = 5
    DEFAULT_EXPLOSION_THRESHOLD = 6

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
    DEFAULT_BASE            = 9
    DEFAULT_STEP_THRESHOLD  = 3
    DEFAULT_MODIFIER        = 0
    DEFAULT_TARGET_NUMBER   = 12

    def initialize(opts={})
      super(opts)
      @base           = opts[:base]           || DEFAULT_BASE
      @step_threshold = opts[:step_threshold] || DEFAULT_STEP_THRESHOLD
      @modifier       = opts[:modifier]       || DEFAULT_MODIFIER
      @expected       = @base + @modifier
      @dice           = dice_for(@expected)
      @bonus          = bonus_for(@expected)
    end

    def value
      @value ||= @dice.times.map do 
        Die.new(@die_opts).value
      end.sum + @bonus
    end

    def successes(vs=DEFAULT_TARGET_NUMBER)
      if vs.is_a? Roll
        vs_roll_successes(vs)
      elsif vs.is_a? Integer
        vs_target_number_successes(vs)
      end
    end

    private
    def dice_for(value)
      value.to_i / @step_threshold
    end

    def bonus_for(value)
      value.to_i % @step_threshold
    end

    def vs_roll_successes(roll)
      vs_target_number_successes(roll.value)
    end

    def vs_target_number_successes(target_number)
      delta = value - target_number

      if delta == 0
         0
      elsif delta > 0
        Square::Table.successes_for(delta)
      else
        -Square::Table.successes_for(-delta)
      end
    end
  end
end
