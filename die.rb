class Die
  DEFAULT_SIDES = 6

  def initialize(opts={})
    @opts   = opts.frozen? ? opts : opts.dup.freeze
    @sides  = opts[:sides] || DEFAULT_SIDES
  end

  def face
    @face ||= rand(@sides) + 1
  end
end
