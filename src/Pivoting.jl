_not_row_one = "May not modify the first row of the Tableau"
_not_col_one = "May not modify the first column of the Tableau"

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

Non-modifying version of `pivot!`
"""
function pivot(T::Tableau, i::Int, j::Int)
    TT = deepcopy(T)
    return pivot!(TT, i, j)
end

function pivot!(T::Tableau)
    i, j = find_pivot(T)
    if i == 0 || j == 0
        return T
    end
    return pivot!(T, i, j)
end

function pivot(T::Tableau)
    TT = deepcopy(T)
    return pivot!(TT)
end

"""
    negate!(T::Tableau, r::Int)

Replace row `r` with its negative.
"""
function negate!(T::Tableau, r::Int)
    r += 1
    if r==1
        error(_not_row_one)
    end
    T.M[r, :] = -T.M[r, :]
    return T
end

"""
    negate(T::Tableau, r::Int)

Replace row `r` with its negative. Nonmodifying version of `negate!`.
"""
function negate(T::Tableau, r::Int)
    TT = deepcopy(T)
    negate!(T, r)
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
    swap!(T::Tableau, i::Int, j::Int)

Swap rows `i` and `j` of a copy of the Tableau.
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
    T
end

#############################################
# OLD STUFF FROM HERE DOWN. IGNORE FOR NOW  #
#############################################

"""
    find_pivot_column(T::Tableau)

Return the index of the column in `T` with the most negative 
value, or `0` if all entries in the bottom row are nonnegative.
"""
function find_pivot_column(T::Tableau)
    bottom = T.M[end, 1:(end - 1)]
    v, j = findmin(bottom)
    return v < 0 ? j : 0
end

"""
    find_least_nonnegative(v::Vector)

Find the index of the least nonnegative entry in `v` or `0` if all entries are negative. 
"""
function find_least_nonnegative(v::Vector)
    m = maximum(v)
    if m < 0
        return 0  # no nonegative values
    end
    idx = 0
    for k in 1:length(v)
        if v[k] >= 0 && v[k] <= m
            m = v[k]
            idx = k
        end
    end
    return idx
end

"""
    find_pivot_row(T::Tableau, j::Int)

Determine the pivot row for column `j` of `T`.
"""
function find_pivot_row(T::Tableau, j::Int)
    rhs = T.M[1:(end - 1), end]
    col = T.M[1:(end - 1), j]

    m = length(col)
    vals = 0 * col

    for i in 1:m
        if col[i] <= 0
            vals[i] = -1
            continue
        else
            vals[i] = rhs[i]//col[i]
        end
    end

    # vals = rhs .// col

    # @show Float64.(vals)

    # for idx in 1:length(col)
    #     if col[idx] <= 0
    #         vals[idx] = -1
    #     end
    # end

    #@show Float64.(vals)

    # _, i = findmin(vals)
    i = find_least_nonnegative(vals)
    return i
end

"""
    find_pivot(T::Tableau)

Determine where to pivot the Tableau. Return `(0,0)` if no pivot exists.
"""
function find_pivot(T::Tableau)
    j = find_pivot_column(T)
    if j == 0
        return 0, 0
    end
    i = find_pivot_row(T, j)
    return i, j
end
