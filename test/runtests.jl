using Test
using SimplexTableaux

@testset "Bare Bones" begin
    A = [2 1 0 9 -1; 1 1 -1 5 1]
    b = [9, 7]
    c = [2, 4, 2, 1, -1]

    T = Tableau(A, b, c, false)

    @test !is_infeasible(T)

    simplex_solve!(T, false)
    @test in_feasible_state(T)
    @test in_optimal_state(T)

    @test in_feasible_state(T)

    set_basis!(T, [3, 4])
    @test !in_feasible_state(T)
end

@testset "Duality" begin
    A = [11 2 11; 8 6 9; 8 8 5; 6 5 8; 4 1 2; 2 -1 4]
    b = [0, 1, 10, 3, 2, 5]
    c = [3, 4, 7]

    T = Tableau(A, b, c)
    dT = dual(T)

    simplex_solve!(T, false)
    v = value(T)

    simplex_solve!(dT, false)
    dv = value(dT)
    @test v == -dv
end
