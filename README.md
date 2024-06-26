# LearningSchedules

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://MurrellGroup.github.io/LearningSchedules.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://MurrellGroup.github.io/LearningSchedules.jl/dev/)
[![Build Status](https://github.com/MurrellGroup/LearningSchedules.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/MurrellGroup/LearningSchedules.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/MurrellGroup/LearningSchedules.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/MurrellGroup/LearningSchedules.jl)

This Julia package provides learning rate schedule types for training deep learning models.

# Examples

Schedules are iterable, and return the learning rate at each iteration. For example, a linear schedule that decreases the learning rate from 1.0 to 0.6 with 4 steps can be created and used as follows:

```julia
julia> using LearningSchedules

julia> linear_schedule = Linear(1.0, 0.6, 4)

julia> for (i, r) in zip(1:6, linear_schedule) # would repeat infinitely without zipping
           println(r)
       end
1.0
0.9
0.8
0.7
0.6
0.6 # final value repeats infinitely
```

In this package, schedules are *stateless*, meaning they are immutable and do not store any information about the current iteration. The schedule state is instead passed around in the underlying `iterate` calls. A state can still be binded to a schedule using `Iterators.Stateful` (which is exported by this package) like so:

```julia
julia> linear_with_state = linear_schedule(); # creates a stateful iterator from the linear schedule

julia> next_rate(linear_with_state)
1.0

julia> next_rate!(linear_with_state)
1.0

julia> next_rate!(linear_with_state)
0.9
```

For more schedule types, see the [documentation](https://MurrellGroup.github.io/LearningSchedules.jl/stable/).
