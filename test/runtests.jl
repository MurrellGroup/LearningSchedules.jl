using LearningSchedules
using Test

@testset "LearningSchedules.jl" begin

    @testset "schedules.jl" begin
        @testset "LinearSchedule" begin
            schedule = LinearSchedule(1.0, 0.6, 4)
            @test collect(r for (i, r) in zip(1:6, schedule)) == [1.0, 0.9, 0.8, 0.7, 0.6, 0.6]
        end
        @testset "BurninSchedule" begin
            schedule = BurninSchedule(1.0, 8.0, 2.0, 0.5)
            @test collect(r for (i, r) in zip(1:8, schedule)) == [1.0, 2.0, 4.0, 8.0, 4.0, 2.0, 1.0, 1.0]
        end
        @testset "BurninHyperbolicSchedule" begin
            schedule = BurninHyperbolicSchedule(1.0, 8.0, 2.0, 0.5, 0.0)
            @test collect(r for (i, r) in zip(1:8, schedule)) == [1.0, 2.0, 4.0, 8.0, 1.6, 1.0, 1.0, 1.0]
        end
    end

    @testset "stateful.jl" begin
        @testset "next_rate!" begin
            schedule = Stateful(LinearSchedule(1.0, 0.6, 4))
            @test next_rate(schedule) == 1.0
            @test next_rate!(schedule) == 1.0
            @test next_rate!(schedule) == 0.9
        end
    end

end
