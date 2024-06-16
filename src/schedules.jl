abstract type AbstractSchedule{T <: AbstractFloat} end

Base.IteratorSize(::Type{<:AbstractSchedule}) = Base.IsInfinite()

"""
    LinearSchedule{T} <: AbstractSchedule{T}
    LinearSchedule(initial::T, final::T, steps::Int)

A linear learning rate schedule, decaying from `initial` to `final` over `steps` iterations.

# Arguments
- `initial::T`: The initial learning rate.
- `final::T`: The final learning rate.
- `steps::Int`: The number of steps to decay over.
"""
struct LinearSchedule{T} <: AbstractSchedule{T}
    initial::T
    final::T
    steps::Int
end

function Base.iterate(schedule::LinearSchedule{T}, (rate, state)::Tuple{T, Int}=(schedule.initial, 0)) where T
    x = clamp(state / schedule.steps, 0, 1)
    rate = schedule.initial + (schedule.final - schedule.initial) * x
    return (rate, (rate, state + 1))
end

"""
    BurninSchedule{T} <: AbstractSchedule{T}
    BurninSchedule(min::T, max::T, inflate::T, decay::T)

A learning rate schedule with exponential inflation and exponential decay states.
The rate starts at `min`, inflates exponentially to `max`, then decays exponentially to `min`.

# Arguments
- `min::T`: The minimum learning rate.
- `max::T`: The maximum learning rate.
- `inflate::T`: The inflation factor during stage 1.
- `decay::T`: The decay factor during stage 2 (starts after max is reached).
"""
struct BurninSchedule{T} <: AbstractSchedule{T}
    min::T
    max::T
    inflate::T
    decay::T
end

function Base.iterate(schedule::BurninSchedule{T}, (rate, state)::Tuple{T, Int}=(schedule.min, 1)) where T
    if state == 1
        rate *= schedule.inflate
        if rate ≥ schedule.max
            rate = schedule.max
            state = 2
        end
    elseif state == 2
        rate *= schedule.decay
        if rate ≤ schedule.min
            rate = schedule.min
            state = 3
        end
    end
    return (rate, (rate, state))
end

"""
    BurninHyperbolicSchedule{T} <: AbstractSchedule{T}
    BurninHyperbolicSchedule(min::T, max::T, inflate::T, decay::T, floor::T)

A learning rate schedule with exponential inflation and hyperbolic decay states.
The rate starts at `min`, inflates exponentially to `max`, then decays hyperbolically to `min`.

# Arguments
- `min::T`: The minimum learning rate.
- `max::T`: The maximum learning rate.
- `inflate::T`: The inflation factor during stage 1.
- `decay::T`: The decay factor during stage 2 (starts after max is reached).
- `floor::T = zero(T)`: The floor value for the decay.
"""
struct BurninHyperbolicSchedule{T} <: AbstractSchedule{T}
    min::T
    max::T
    inflate::T
    decay::T
    floor::T
end

function Base.iterate(schedule::BurninHyperbolicSchedule{T}, (rate, state)::Tuple{T, Int}=(schedule.min, 1)) where T
    if state == 1
        rate *= schedule.inflate
        if rate ≥ schedule.max
            rate = schedule.max
            state = 2
        end
    elseif state == 2
        rate = (rate - schedule.floor) / (one(T) + schedule.decay * (rate - schedule.floor))
        if rate ≤ schedule.min
            rate = schedule.min
            state = 3
        end
    end
    return (rate, (rate, state))
end
