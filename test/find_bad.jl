using SimpleTableaux, LinearAlgebra, ProgressMeter

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
    if norm(x - xx) > 1e-6
        return false
    end

    return true
end

"""
    find_bad(nv, nc, m=100, reps=100)

Try to find a failure for `pivot_solve`.
"""
function find_bad(nv, nc, m=100, reps=100)
    P = Progress(reps)
    for _ in 1:reps
        T = random_example(nv, nc, m)
        if !check_solution(T)
            @info "Found a bad example"
            return T
        end
        next!(P)
    end
    @info "No errors found"
    return nothing
end
