using LearningSchedules
using Test

@testset "LearningSchedules.jl" begin

    @testset "schedules.jl" begin
        @testset "Linear" begin
            linear = Linear(1.0, 0.6, 4)
            @test collect(r for (i, r) in zip(1:6, linear)) == [1.0, 0.9, 0.8, 0.7, 0.6, 0.6]
        end
        @testset "Burnin" begin
            burnin = Burnin(1.0, 8.0, 2.0, 0.5)
            @test collect(r for (i, r) in zip(1:8, burnin)) == [1.0, 2.0, 4.0, 8.0, 4.0, 2.0, 1.0, 1.0]
        end
        @testset "BurninHyperbolic" begin
            burninh = BurninHyperbolic(1.0, 8.0, 2.0, 0.5, 0.0)
            @test collect(r for (i, r) in zip(1:8, burninh)) == [1.0, 2.0, 4.0, 8.0, 1.6, 1.0, 1.0, 1.0]
        end
    end

    @testset "stateful.jl" begin
        @testset "next_rate!" begin
            linear = Stateful(Linear(1.0, 0.6, 4))
            @test next_rate(linear) == 1.0
            @test next_rate!(linear) == 1.0
            @test next_rate!(linear) == 0.9
        end
    end

end
