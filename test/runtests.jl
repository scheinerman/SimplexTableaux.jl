using Test
using SimpleTableaux
using LinearAlgebra
using DataFrames

@testset "Simple start" begin
    A = [1 2 3 4; 5 6 7 8]
    b = [1; 3//2]
    c = [5; 6; 9; 2]
    T = Tableau(A, b, c)
    x = pivot_solve!(T, false)

    @test dot(c, x) == T.M[end, end]
end
