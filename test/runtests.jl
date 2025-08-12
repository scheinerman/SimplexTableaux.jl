using Test
using SimplexTableaux

@testset "Bare Bones" begin
    A = [2 1 0 9 -1; 1 1 -1 5 1]
    b = [9, 7]
    c = [2, 4, 2, 1, -1]

    T = Tableau(A, b, c, false)

    simplex_solve!(T, false)
    @test is_feasible(T)
    @test is_optimal(T)

    @test is_feasible(T)

    set_basis!(T, [3, 4])
    @test !is_feasible(T)
end
