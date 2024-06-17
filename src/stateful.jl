# binding the state to an iterator
import Base.Iterators: Stateful

(schedule::LearningRateSchedule)() = Stateful(schedule)

function (schedule::LearningRateSchedule)(initial_state)
    stateful = schedule()
    stateful.nextvalstate = initial_state
    return stateful
end

"""
    next_rate!(schedule::Stateful{<:LearningRateSchedule})

Update the schedule and return the next rate.

See also: [`next_rate`](@ref)

# Examples

```jldoctest
julia> linear_with_state = Linear(1.0, 0.0, 10)(); # stateful

julia> next_rate!(linear_with_state)
1.0

julia> next_rate!(linear_with_state)
0.9
```
"""
next_rate!(schedule::Stateful{<:LearningRateSchedule}) = popfirst!(schedule)

"""
    next_rate(schedule::Stateful{<:LearningRateSchedule})

See also: [`next_rate!`](@ref)

# Examples

```jldoctest
julia> linear_with_state = Linear(1.0, 0.0, 10)(); # stateful

julia> next_rate(linear_with_state)
1.0

julia> next_rate!(linear_with_state)
1.0

julia> next_rate(linear_with_state)
0.9
```
"""
next_rate(schedule::Stateful{<:LearningRateSchedule}) = peek(schedule)