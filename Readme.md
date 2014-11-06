Read the comments in each file -- fatelike, master_system, shadowrunlike and 
square_system -- for details about what each die rolling system looks like. 

    require './experiment'
    require './systems/shadowrun'
    require './systems/fate'
    require './systems/hot_war'
    require './systems/square'
    require './systems/master'

    shadowrun_experiment = Experiment.new(Shadowrun)
    puts shadowrun_experiment

    fate_experiment = Experiment.new(Fate)
    puts fate_experiment

    # ... etc. for HotWar, Square and Master

    # Try with a larger sample size than the default (10,000):
    e = Experiment.new(Square, sample_size:1_000_000)

    # Modify the number of dice in the roll (default 5):
    e = Experiment.new(Master, roll:{dice:10})

    # Modify the die used in the roll:
    world_of_darkness_experiment = Experiment.new(Shadowrun, roll:{die:{sides:10, success_threshold:8, explosion_threshold:10}})
