"""
    pivot_solve!(T::Tableau, verbose::Bool=true)

Same as `pivot_solve` but this version modifies `T`.
"""
function pivot_solve!(T::Tableau, verbose::Bool=true)
    count = 0
    while true
        if verbose
            println("Iteration $count")
            println(T)
            println()
            count += 1
        end
        i, j = find_pivot(T)
        if i == 0 || j == 0
            break
        end
        pivot!(T, i, j)
    end # end while

    if verbose
        val = Exact(T.M[end,end])
        println("Optimum value = $val")
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
    x = zeros(TabEntry, T.n_vars)

    for i in 1:(T.n_vars)
        col = T.M[1:(T.n_cons), i]
        if _is_basis_vector(col)
            j = findfirst(col .== 1)
            x[i] = T.M[j, end]
        end
    end
    return x
end
