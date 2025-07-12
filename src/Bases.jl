"""
    find_a_basis(T::Tableau)

Return a feasible basis for the LP in `T` or `nothing` if none exists.
"""
function find_a_basis(T::Tableau)::Vector{Int}
    r, c = size(T.A)
    for B in combinations(1:c, r)
        TT = set_basis!(T, B)
        if is_feasible(TT)
            return B
        end
    end
    @info "No basis found"
    return zeros(Int, r)
end

"""
    find_all_bases(T::Tableau)

Return a list of all feasible bases for `T`.
"""
function find_all_bases(T::Tableau)
    r, c = size(T.A)
    TT = deepcopy(T)
    result = [B for B in combinations(1:c, r) if is_feasible(set_basis!(TT, B))]

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
