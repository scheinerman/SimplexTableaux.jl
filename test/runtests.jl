using Test
using SimplexTableaux

@testset "Bare Bones" begin
    A = [2 1 0 9 -1; 1 1 -1 5 1]
    b = [9, 7]
    c = [2, 4, 2, 1, -1]

    T = Tableau(A, b, c, false)
    pivot!(T, 1, 2)
    pivot!(T, 2, 1)
    @test is_feasible(T)

    basis_pivot!(T, [4, 5])
    @test is_feasible(T)

    basis_pivot!(T, [3, 4])
    @test !is_feasible(T)
end
