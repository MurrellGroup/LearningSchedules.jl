var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = LearningSchedules","category":"page"},{"location":"#LearningSchedules","page":"Home","title":"LearningSchedules","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for LearningSchedules.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [LearningSchedules]","category":"page"},{"location":"#LearningSchedules.Burnin","page":"Home","title":"LearningSchedules.Burnin","text":"Burnin{T} <: TimeBased{T}\nBurnin(min::T, max::T, inflate::T, decay::T)\n\nA learning rate schedule with exponential inflation and exponential decay stages. The rate starts at min, inflates exponentially to max, then decays exponentially to min.\n\nArguments\n\nmin::T: The minimum learning rate.\nmax::T: The maximum learning rate.\ninflate::T: The inflation factor during stage 1.\ndecay::T: The decay factor during stage 2 (starts after max is reached).\n\n\n\n\n\n","category":"type"},{"location":"#LearningSchedules.BurninHyperbolic","page":"Home","title":"LearningSchedules.BurninHyperbolic","text":"BurninHyperbolic{T} <: TimeBased{T}\nBurninHyperbolic(min::T, max::T, inflate::T, decay::T, floor::T)\n\nA learning rate schedule with exponential inflation and hyperbolic decay stages. The rate starts at min, inflates exponentially to max, then decays hyperbolically to min.\n\nArguments\n\nmin::T: The minimum learning rate.\nmax::T: The maximum learning rate.\ninflate::T: The inflation factor during stage 1.\ndecay::T: The decay factor during stage 2 (starts after max is reached).\nfloor::T: idk ask Ben or look at the code lol\n\n\n\n\n\n","category":"type"},{"location":"#LearningSchedules.Linear","page":"Home","title":"LearningSchedules.Linear","text":"Linear{T} <: StepBased{T}\nLinear(initial::T, final::T, steps::Int)\n\nA linear learning rate schedule, decaying from initial to final over steps iterations.\n\nArguments\n\ninitial::T: The initial learning rate.\nfinal::T: The final learning rate.\nsteps::Int: The number of steps to decay over.\n\n\n\n\n\n","category":"type"},{"location":"#LearningSchedules.next_rate!-Tuple{Stateful{<:LearningSchedules.LearningRateSchedule}}","page":"Home","title":"LearningSchedules.next_rate!","text":"next_rate!(schedule::Stateful{<:LearningRateSchedule})\n\nUpdate the schedule and return the next rate.\n\nSee also: next_rate\n\nExamples\n\njulia> linear_with_state = Linear(1.0, 0.0, 10)(); # stateful\n\njulia> next_rate!(linear_with_state)\n1.0\n\njulia> next_rate!(linear_with_state)\n0.9\n\n\n\n\n\n","category":"method"},{"location":"#LearningSchedules.next_rate-Tuple{Stateful{<:LearningSchedules.LearningRateSchedule}}","page":"Home","title":"LearningSchedules.next_rate","text":"next_rate(schedule::Stateful{<:LearningRateSchedule})\n\nSee also: next_rate!\n\nExamples\n\njulia> linear_with_state = Linear(1.0, 0.0, 10)(); # stateful\n\njulia> next_rate(linear_with_state)\n1.0\n\njulia> next_rate!(linear_with_state)\n1.0\n\njulia> next_rate(linear_with_state)\n0.9\n\n\n\n\n\n","category":"method"}]
}