class Roll
  DEFAULT_DICE = 3

  def initialize(opts={})
    @opts     = opts.frozen? ? opts : opts.dup.freeze

    @dice     = @opts[:dice] || DEFAULT_DICE
    @die_opts = @opts[:die]  || {}
  end
end
