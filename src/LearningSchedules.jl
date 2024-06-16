module LearningSchedules

include("schedules.jl")
export LinearSchedule, BurninSchedule, BurninHyperbolicSchedule

include("stateful.jl")
export Stateful, next_rate!, next_rate

end
