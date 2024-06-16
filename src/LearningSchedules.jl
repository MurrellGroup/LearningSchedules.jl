module LearningSchedules

include("schedules.jl")
export Linear, Burnin, BurninHyperbolic

include("stateful.jl")
export Stateful, next_rate!, next_rate

end
