module LearningSchedules

mutable struct LearningRateSchedule
    lr::Float32
    state::Int
    f!::Function
end

function next_rate(lrs::LearningRateSchedule)
    return lrs.f!(lrs)
end

function burnin_learning_schedule(min_lr::Float32, max_lr::Float32, inflate::Float32, decay::Float32)
    function f!(lrs::LearningRateSchedule)
        if lrs.state == 1
            lrs.lr = lrs.lr * inflate
            if lrs.lr > max_lr
                lrs.state = 2
                lrs.lr = lrs.lr * decay
            end
        end
        if lrs.state == 2
            lrs.lr = lrs.lr * decay
            if lrs.lr < min_lr
                lrs.state = 3
                lrs.lr = min_lr
            end
        end
        return lrs.lr
    end
    return LearningRateSchedule(min_lr, 1, f!)
end

function burnin_hyperbolic_schedule(min_lr::Float32, max_lr::Float32, inflate::Float32, decay::Float32; floor::Float32 = 0.0f0)
    function f!(lrs::LearningRateSchedule)
        #Exponential inflation, followed by hyperbolic decay
        if lrs.state == 1
            lrs.lr = lrs.lr * inflate
            if lrs.lr > max_lr
                lrs.state = 2
            end
        end
        if lrs.state == 2
            #hyperbolic decay
            lrs.lr = (lrs.lr-floor) / (1.0f0 + decay * (lrs.lr-floor))
            if lrs.lr < min_lr
                lrs.state = 3
                lrs.lr = min_lr
            end
        end
        return lrs.lr
    end
    return LearningRateSchedule(min_lr, 1, f!)
end

#=
testlrs = burnin_hyperbolic_schedule(0.000001f0, 0.0005f0, 1.17f0, 4.0f0)
testlr = Float32[]
batches = Float32[]
for i in 1:2000
    push!(testlr, next_rate(testlrs))
    push!(batches, i*500)
end
pl = plot(batches ./ 20000, testlr)
savefig(pl, "test_lr_schedule.svg")
=#

function linear_decay_schedule(max_lr::Float32, min_lr::Float32, steps::Int)
    function f!(lrs::LearningRateSchedule)
        lrs.lr = max(min_lr, lrs.lr - (max_lr - min_lr)/steps)
        return lrs.lr
    end
    return LearningRateSchedule(max_lr, 1, f!)
end

export burnin_learning_schedule, next_rate, burnin_hyperbolic_schedule, linear_decay_schedule

end
