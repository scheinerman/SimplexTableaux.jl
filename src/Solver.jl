"""
    pivot_solve!(T::Tableau, verbose::Bool=true)

Same as `pivot_solve` but this version modifies `T`.
"""
function pivot_solve!(T::Tableau, verbose::Bool=true)
    count = 0
    max_pivots = T.n_vars * T.n_cons
    while true
        if verbose
            #println("Iteration $count")
            println(T)
            println()
        end
        i, j = find_pivot(T)
        if i == 0 || j == 0
            break
        end
        verbose && println("\nPivot at ($i,$j)\n")
        old_pivot!(T, i, j)

        count += 1
        if count > max_pivots
            verbose && @info "Max pivots exceeded"
            break
        end
    end # end while

    if verbose
        val = Exact(T.M[end, end])
        print("Optimum value after $count iterations = $val")
        if denominator(val.val) ≠ 1
            obj_val = Float64.(val.val)
            println(" = $obj_val")
        else
            println()
        end
        println()
    end

    return _get_x(T)
end # end pivot_solve

"""
    pivot_solve(T::Tableau, verbose::Bool=true)

Solve the linear program in `T` by pivoting. 
With `verbose` set to `true` all steps of the solution are shown.

Returns the optimal solution to the linear program. 
"""
function pivot_solve(T::Tableau, verbose::Bool=true)
    TT = deepcopy(T)
    return pivot_solve!(TT, verbose)
end

"""
    _is_basis_vector(x::Vector)::Bool

Determine if `x` is vector with a single entry equal to 1 and the rest equal to 0.
"""
function _is_basis_vector(x::Vector)::Bool
    x = sort(x)
    n = length(x)
    y = zeros(Int, n)
    y[end] = 1

    return x == y
end

"""
    _get_x(T::Tableau)

Extract the values of the solution to `T` after finish pivoting.
"""
function _get_x(T::Tableau)
    x = zeros(_Exact, T.n_vars)

    for i in 1:(T.n_vars)
        # col = T.M[1:(T.n_cons), i]
        col = T.M[:, i]

        if _is_basis_vector(col)
            j = findfirst(col .== 1)
            x[i] = T.M[j, end]
        end
    end
    return x
end
