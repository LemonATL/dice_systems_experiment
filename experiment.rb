require 'json'
require './array'

class Experiment
  attr_reader :data

  DEFAULT_SAMPLE_SIZE = 10_000

  def initialize(die_module, opts={})
    @die_module   = die_module
    @opts         = opts.dup.freeze
    @sample_size  = @opts[:sample_size] || DEFAULT_SAMPLE_SIZE
    @roll_opts    = @opts[:roll]        || {}

    run!
  end

  def run!
    @data = @sample_size.times.map do 
      @die_module::Roll.new(@roll_opts).successes
    end.sort
  end

  def to_s
    return @to_s if defined? @to_s
    @to_s = ''

    @to_s << "[#{@die_module} rules]\n"
    @to_s << "\tOPTS:\n"
    @to_s << "#{JSON.pretty_generate(@roll_opts)}\n"
    @to_s << "\tMEAN:\t\t#{@data.mean}\n"
    @to_s << "\tMEDIAN:\t\t#{@data.median}\n"
    @to_s << "\tRANGE:\t\t#{@data.min} - #{@data.max}\n"
    @to_s << "\tVARIANCE:\t#{@data.variance.round(2)}\n"

    @to_s
  end

end
