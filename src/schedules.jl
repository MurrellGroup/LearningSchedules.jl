abstract type LearningRateSchedule{T <: AbstractFloat} end

Base.IteratorSize(::Type{<:LearningRateSchedule}) = Base.IsInfinite()

initial_state(::LearningRateSchedule) = error("not defined for abstract type")
Base.iterate(schedule::LearningRateSchedule) = iterate(schedule, initial_state(schedule))

abstract type StepBased{T} <: LearningRateSchedule{T} end
abstract type TimeBased{T} <: LearningRateSchedule{T} end

"""
    Linear{T} <: StepBased{T}
    Linear(initial::T, final::T, steps::Int)

A linear learning rate schedule, decaying from `initial` to `final` over `steps` iterations.

# Arguments
- `initial::T`: The initial learning rate.
- `final::T`: The final learning rate.
- `steps::Int`: The number of steps to decay over.
"""
struct Linear{T} <: StepBased{T}
    initial::T
    final::T
    steps::Int
end

initial_state(schedule::Linear) = (schedule.initial, 0)

function Base.iterate(schedule::Linear{T}, (rate, step)::Tuple{T, Int}) where T
    x = clamp(step / schedule.steps, 0, 1)
    rate = schedule.initial + (schedule.final - schedule.initial) * x
    return (rate, (rate, step + 1))
end

"""
    Burnin{T} <: TimeBased{T}
    Burnin(min::T, max::T, inflate::T, decay::T)

A learning rate schedule with exponential inflation and exponential decay stages.
The rate starts at `min`, inflates exponentially to `max`, then decays exponentially to `min`.

# Arguments
- `min::T`: The minimum learning rate.
- `max::T`: The maximum learning rate.
- `inflate::T`: The inflation factor during stage 1.
- `decay::T`: The decay factor during stage 2 (starts after max is reached).
"""
struct Burnin{T} <: TimeBased{T}
    min::T
    max::T
    inflate::T
    decay::T
end

initial_state(schedule::Burnin) = (schedule.min, 0)

function Base.iterate(schedule::Burnin{T}, (rate, stage)::Tuple{T, Int}) where T
    if stage == 0
        stage = 1
    elseif stage == 1
        rate *= schedule.inflate
        if rate ≥ schedule.max
            rate = schedule.max
            stage = 2
        end
    elseif stage == 2
        rate *= schedule.decay
        if rate ≤ schedule.min
            rate = schedule.min
            stage = 3
        end
    end
    return (rate, (rate, stage))
end

"""
    BurninHyperbolic{T} <: TimeBased{T}
    BurninHyperbolic(min::T, max::T, inflate::T, decay::T, floor::T)

A learning rate schedule with exponential inflation and hyperbolic decay stages.
The rate starts at `min`, inflates exponentially to `max`, then decays hyperbolically to `min`.

# Arguments
- `min::T`: The minimum learning rate.
- `max::T`: The maximum learning rate.
- `inflate::T`: The inflation factor during stage 1.
- `decay::T`: The decay factor during stage 2 (starts after max is reached).
- `floor::T`: idk ask Ben or look at the code lol
"""
struct BurninHyperbolic{T} <: TimeBased{T}
    min::T
    max::T
    inflate::T
    decay::T
    floor::T
end

initial_state(schedule::BurninHyperbolic) = (schedule.min, 0)

function Base.iterate(schedule::BurninHyperbolic{T}, (rate, stage)::Tuple{T, Int}) where T
    if stage == 0
        stage = 1
    elseif stage == 1
        rate *= schedule.inflate
        if rate ≥ schedule.max
            rate = schedule.max
            stage = 2
        end
    elseif stage == 2
        rate = (rate - schedule.floor) / (one(T) + schedule.decay * (rate - schedule.floor))
        if rate ≤ schedule.min
            rate = schedule.min
            stage = 3
        end
    end
    return (rate, (rate, stage))
end
