using SimplexTableaux

# Try to implement dual simplex algorithm

function dual_find_pivot(T::Tableau, r::Int)
    # validate r
    if r<1 || r>T.n_cons
        error("Invalid row $r")
    end
    n = T.n_vars
    nn = n + 1
    if T[r, nn] ≥ 0
        return 0    # no pivot in this row 
    end

    heads = T.M[1, 2:(end - 1)]
    row = T.M[r + 1, 2:(end - 1)]

    ratios = zeros(Rational{BigInt}, T.n_vars)

    for i in 1:n
        if row[i] < 0
            ratios[i] = heads[i] // row[i]
        else
            ratios[i]=1//0
        end
    end

    v, j = findmin(ratios)
    if v==1//0
        return 0
    end
    return j
end

"""
    dual_find_pivot(T::Tableau)

Find a pivot in `T` for the dual simplex method. Returns `(i,j)` 
for the location of the pivot and `(0,0)` if no valid pivot is 
available. 
"""
function dual_find_pivot(T::Tableau)
    RHS = T.M[2:end, end]

    m, i = findmin(RHS)

    if m ≥ 0
        return 0, 0   # no pivot
    end
    j = dual_find_pivot(T, i)
    return i, j
end

function dual_simplex_solve!(T::Tableau, verbose::Bool=true)
    B = get_basis(T)
    if 0∈B
        if verbose
            @info "No basis set; cannot proceed with dual simplex method."
        end
        return nothing
    end

    if !in_dual_feasible_state(T)
        if verbose
            @info "Tableau is not dual feasible; cannot proceed with dual simplex method"
        end
    end

    pivot_count = 0
    while !in_optimal_state(T)
        p = dual_find_pivot(T)
        if 0∈p
            if verbose
                @info "This linear program is ... "
            end
            return nothing
        end

        pivot!(T, p...)
        pivot_count += 1
        if verbose
            println("Pivot $(pivot_count) at $p\n")
            println(T)
        end
    end

    x = basic_vector(T)

    if is_canonical(T)
        n = T.n_vars-T.n_cons
        x = x[1:n]
    end
    v = SimplexTableaux.Exact(value(T))

    if verbose
        println("Optimality reached. Pivot count = $pivot_count")
        println("Minimal value = $v = $(Float64(value(T)))")
    end

    return x
end
