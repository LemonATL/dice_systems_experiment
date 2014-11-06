Read the comments in each file -- fatelike, master_system, shadowrunlike and 
square_system -- for details about what each die rolling system looks like. 

    require './experiment'
    require './shadowrunlike'
    require './fatelike'
    require './square_system'
    require './master_system'

    shadowrunlike_experiment = Experiment.new(Shadowrunlike)
    puts shadowrunlike_experiment

    fatelike_experiment = Experiment.new(Fatelike)
    puts fatelike_experiment

    # ... etc. for SquareSystem and MasterSystem

    # Try with a larger sample size than the default (10,000):
    e = Experiment.new(SquareSystem, sample_size:1_000_000)

    # Modify the number of dice in the roll (default 5):
    e = Experiment.new(MasterSystem, roll:{dice:10})

    # Modify the die used in the roll:
    world_of_darkness_experiment = Experiment.new(Shadowrunlike, roll:{die:{sides:10, success_threshold:8, explosion_threshold:10}})
