using Test
using SimpleTableaux
using LinearAlgebra
using DataFrames

@testset "Dumb start" begin
    A = [1 2 3 4; 5 6 7 8]
    b = [1; 3]
    c = [5; 6; 9; 2]
    T = Tableau(A, b, c)
    @test true
end
