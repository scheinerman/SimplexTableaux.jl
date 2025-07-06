_not_row_one = "May not modify the header row of the Tableau"
_not_col_one = "May not modify the z column of the Tableau"

"""
    pivot!(T::Tableau, i::Int, j::Int)

Modify `T` by doing a pivot operation at contraint `i` 
and variable x_`j`.
"""
function pivot!(T::Tableau, i::Int, j::Int)
    M = T.M  # for easier access

    i += 1
    j += 1

    # make i,j-entry a 1
    mij = M[i, j]
    M[i, :] .//= mij

    # clear other entries in column j
    for a in 1:(T.n_cons + 1)
        if a == i
            continue
        end
        M[a, :] += -M[a, j] * M[i, :]
    end

    return T
end

"""
    pivot(T::Tableau, i::Int, j::Int)

Non-modifying version of `pivot!`.
"""
function pivot(T::Tableau, i::Int, j::Int)
    TT = deepcopy(T)
    return pivot!(TT, i, j)
end

"""
    scale!(T::Tableau, r::Int, s::_Exact)

Multiply row `r` of `T` by `s` (which must be nonzero).
"""
function scale!(T::Tableau, r::Int, s::_Exact)
    r += 1
    if r==1
        error(_not_row_one)
    end
    if s == 0
        error("May not scale by 0")
    end
    T.M[r, :] *= s
    return T
end

"""
    scale(T::Tableau, r::Int, s::_Exact)

Non-modifying version of 
"""
function scale(T::Tableau, r::Int, s::_Exact)
    TT = deepcopy(T)
    scale!(TT, r, s)
    return TT
end

"""
    swap!(T::Tableau, i::Int, j::Int)

Swap constraints `i` and `j` of the Tableau.
"""
function swap!(T::Tableau, i::Int, j::Int)
    i += 1
    j += 1
    if i<2 || j<2
        error(_not_row_one)
    end

    if i==j
        return T
    end

    row_i = T.M[i, :]
    row_j = T.M[j, :]

    T.M[j, :] = row_i
    T.M[i, :] = row_j

    T
end
"""
    swap(T::Tableau, i::Int, j::Int)

Non-modifying version of `swap!`.
"""
function swap(T::Tableau, i::Int, j::Int)
    TT = deepcopy(T)
    swap!(TT, i, j)
end

"""
    basis_pivot!(T::Tableau, vars)

Pivot `T` so that the variables specified in `vars`
are the basic variables. 
"""
function basis_pivot!(T::Tableau, vars)
    # bop up indices by 1 and make a list
    idx = [j+1 for j in vars]
    idx = vcat(1, idx)

    B = T.M[:, idx]
    BB = invx(B)  # will fail if B is not invertible
    new_M = BB*T.M

    r, c = size(T.M)
    for i in 1:r
        for j in 1:c
            T.M[i, j] = new_M[i, j]
        end
    end
    return T
end

"""
    basis_pivot(T::Tableau, vars)

Non-modifying version of `basis_pivot!`.
"""
function basis_pivot(T::Tableau, vars)
    TT = deepcopy(T)
    basis_pivot!(TT, vars)
    return TT
end
