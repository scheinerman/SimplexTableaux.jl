function _phase_one_tableau(T::Tableau)
    A, b, c = get_Abc(T)
    m = T.n_cons
    n = T.n_vars

    bb = deepcopy(b)
    AA = deepcopy(A)

    # ensure RHS is nonnegative
    for i in 1:m
        if bb[i] < 0
            bb[i] = -bb[i]
            AA[i, :] = -AA[i, :]
        end
    end

    # glue an identity matrix to RHS
    AA = hcat(AA, eye(Int, m))

    # create artifical c 
    cc = vcat(0*c, ones(Int, m))

    TT = Tableau(AA, bb, cc, false)

    B = collect((n + 1):(n + m))
    set_basis!(TT, B)

    return TT
end

"""
    find_a_basis(T::Tableau, verbose::Bool=true)

Return a feasible basis for the LP in `T` or `nothing` if none exists.
"""
function find_a_basis(T::Tableau, verbose::Bool=true)
    TT = _phase_one_tableau(T)
    n = T.n_vars
    m = T.n_cons

    simplex_solve!(TT, false)
    v = value(TT)
    if v>0
        if verbose
            @info "No basis found."
        end
        return 0*get_basis(TT)
    end

    xx = basic_vector(TT)
    xx = xx[1:n]

    # B = findall(!iszero, xx)
    B = infer_basis!(T, xx)
    return B
end

"""
    find_all_bases(T::Tableau)

Return a list of all feasible bases for `T`.
"""
function find_all_bases(T::Tableau)
    r, c = size(T.A)
    TT = deepcopy(T)
    result = [
        B for B in combinations(1:c, r) if
        check_basis(TT, B) && in_feasible_state(set_basis!(TT, B))
    ]

    # T.M = TT.M
    # T.B = TT.B

    return result
end

"""
    basic_vector(T::Tableau)

Return the basic vector for `T`. This is the vector in which all
nonbasic variables are 0. 
"""
function basic_vector(T::Tableau)
    if 0 ∈ T.B
        error("No basis set for this tableau")
    end
    r, c = size(T.A)
    v = zeros(_Exact, c)
    TT = set_basis!(T, T.B)

    for i in 1:r
        v[T.B[i]] = TT.M[i + 1, end]
    end
    return Rational.(v)
end
