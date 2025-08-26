
"""
    find_pivot(T::Tableau, i::Int)

Find a valid pivot in column `i`.
"""
function find_pivot(T::Tableau, i::Int)
    # Check that objective function coefficient is not negative
    ci = T.M[1, i + 1]
    if ci < 0
        @info "Invalid column for pivot, $i."
        return 0, 0
    end

    ai = T.M[2:end, i + 1]   # column i of A matrix 
    b = T.M[2:end, end]     # RHS vector

    ratios = b
    for j in 1:length(b)
        if ai[j] != 0
            ratios[j] //= ai[j]
        else
            ratios[j] = 1//0   # set to infinity if no good
        end
    end

    for j in 1:T.n_cons
        if ratios[j] < 0 || ai[j] <= 0
            ratios[j] = 1//0  # render negative ratios invalid
        end
    end

    # get index for smallest ratio
    min_rat = minimum(ratios)

    if min_rat == 1//0
        return 0, 0
    end

    j = findfirst(x -> x==min_rat, ratios)

    # now find the basis vector with a 1 in position j 
    for k in T.B
        ak = T.M[2:end, k + 1]
        if ak[j] == 1  # this is the one we want
            return i, k
        end
    end

    return (i, 0)  # this shouldn't happen!
end

"""
    find_pivot(T::Tableau)

Find a valid pivot for `T` or return `(0,0)` if none exists. 
"""
function find_pivot(T::Tableau)
    c = find_pivot_column(T)
    if c == 0
        return 0, 0
    end
    p = find_pivot(T, c)
    return p
end

"""
    find_pivot_column(T::Tableau)

Find a column with the most negative reduced cost 
(i.e., the most positive value in the top row of the tableau).
"""
function find_pivot_column(T::Tableau)
    reduced_costs = T.M[1, 2:(end - 1)]   # top row between separators
    rc, j = findmax(reduced_costs)
    if rc <= 0
        return 0   # no pivot possible
    end
    return j
end

"""
    simplex_solve!(T::Tableau, verbose::Bool=true)

Solve `T` using the simplex method. 
"""
function simplex_solve!(T::Tableau, verbose::Bool=true)
    if 0 ∈ T.B
        B = find_a_basis(T, verbose)
        if 0 ∈ B
            if verbose
                @info "This linear program is infeasible."
            end
            return nothing
        end
        if verbose
            println("Starting basis found: $B")
        end
        set_basis!(T, B)
    end

    if verbose
        println("Starting tableau\n")
        println(T)
    end

    pivot_count = 0

    while !in_optimal_state(T)
        p = find_pivot(T)
        if 0 ∈ p
            if verbose
                @info "This linear program is unbounded"
            end
            return nothing
        end
        basis_pivot!(T, p...)
        pivot_count += 1
        if verbose
            in, out = p
            println(
                "Pivot $(pivot_count): column $out leaves basis and column $in enters\n"
            )
            println(T)
        end
    end

    x = basic_vector(T)
    v = Exact(value(T))

    if verbose
        println("Optimality reached. Pivot count = $pivot_count")
        println("Minimal value = $v = $(Float64(value(T)))")
    end

    return x
end
