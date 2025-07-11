export find_a_basis, find_all_bases, basis_vector

"""
    find_a_basis(T::Tableau)

Return a feasible basis for the LP in `T` or `nothing` if none exists.
"""
function find_a_basis(T::Tableau)
    r, c = size(T.A)
    for B in combinations(1:c, r)
        TT = set_basis!(T, B)
        if is_feasible(TT)
            return B
        end
    end
    @info "No basis found"
    nothing
end

"""
    find_all_bases(T::Tableau)

Return a list of all feasible bases for `T`.
"""
function find_all_bases(T::Tableau)
    r, c = size(T.A)
    TT = deepcopy(T)
    result =  [B for B in combinations(1:c, r) if is_feasible(set_basis!(T, B))]
   
    T.M = TT.M
    T.B = TT.B 
    
    return result
end

function basis_vector(T::Tableau, B)
    B = collect(B)
    r, c = size(T.A)
    v = zeros(_Exact, c)
    TT = set_basis!(T, B)

    for i in 1:r
        v[B[i]] = TT.M[i + 1, end]
    end
    return v
end
