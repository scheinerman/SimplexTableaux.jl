
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

    ratios = b .// ai
    for j in 1:T.n_cons
        if ratios[j] < 0
            ratios[j] = 1//0  # render negative ratios invalid
        end
    end

    # get index for smallest ratio
    min_rat = minimum(ratios)
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

function find_pivot_column(T::Tableau)
    for i in 1:T.n_vars
        if T.M[1, i + 1] > 0
            return i
        end
    end
    return 0 # no valid column
end

"""
    simplex_solve!(T::Tableau, verbose::Bool=true)

Solve `T` using the simplex method. 
"""
function simplex_solve!(T::Tableau, verbose::Bool=true)
    if 0 ∈ T.B
        error("Sorry: User must provide a valid basis to get started. Try: find_a_basis(T)")
    end

    if verbose
        println("Starting tableau\n")
        println(T)
    end

    while !is_optimal(T)
        p = find_pivot(T)
        if 0 ∈ p
            @error "Cannot solve this LP. Is it infeasible? Unbounded?"
        end
        pivot!(T, p...)
        if verbose
            in, out = p
            println("Column $out leaves basis and column $in enters\n")
            println(T)
        end
    end

    x = basic_vector(T)
    v = Exact(value(T))

    if verbose
        println("Optimality reached")
        println("Value = $v = $(Float64(value(T)))")
    end

    return x
end
