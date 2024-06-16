# binding the state to an iterator
import Base.Iterators: Stateful

(schedule::AbstractSchedule)() = Stateful(schedule)

"""
    next_rate!(schedule::Stateful{<:AbstractSchedule})

Update the schedule and return the next rate.

See also: [`next_rate`](@ref)

# Examples

```jldoctest
julia> schedule = Stateful(LinearSchedule(1.0, 0.0, 10));

julia> next_rate!(schedule)
1.0

julia> next_rate!(schedule)
0.9
```
"""
const next_rate! = popfirst!

"""
    next_rate(schedule::Stateful{<:AbstractSchedule})

See also: [`next_rate!`](@ref)

# Examples

```jldoctest
julia> schedule = Stateful(LinearSchedule(1.0, 0.0, 10));

julia> next_rate(schedule)
1.0

julia> next_rate!(schedule)
1.0

julia> next_rate(schedule)
0.9
```
"""
const next_rate = peek