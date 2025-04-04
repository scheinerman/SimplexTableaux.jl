using Test
using SimplexTableaux
using LinearAlgebra
using DataFrames

"""
    random_example(n_vars::Int, n_cons::Int, modulus::Int=10)

Create a random instance of a `Tableau` with `n_vars` variables, 
`n_cons` constraints in which all data are chosen IID uniformly
from `{1,2,...,modulus}`.
"""
function random_example(n_vars::Int, n_cons::Int, modulus::Int=10)::Tableau
    f(x::Int) = mod1(x, modulus)
    A = f.(rand(Int, n_cons, n_vars))
    b = f.(rand(Int, n_cons))
    c = f.(rand(Int, n_vars))
    return Tableau(A, b, c)
end

"""
    check_solution(T::Tableau, x::Vector)::Bool

Compute the solution to the LP in `T` and make sure its correct.
"""
function check_solution(T::Tableau)::Bool
    T = deepcopy(T)
    x = pivot_solve!(T, false)
    if any(T.A * x .> T.b)
        return false
    end

    if any(x .< 0)
        return false
    end

    if dot(T.c, x) != T.M[end, end]
        return false
    end

    xx = lp_solve(T)
    if norm(Float64.(x) - xx) > 1e-6
        return false
    end

    return true
end

function multi_test(nv, nc, m=100, reps=10)
    return all(check_solution(random_example(nv, nc, m)) for _ in 1:reps)
end

@test multi_test(5, 11)
@test multi_test(11, 5)
@test multi_test(10, 20)
@test multi_test(20, 20)
@test multi_test(20, 10)
