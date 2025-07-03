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

"""
    pivot!(T::Tableau, i::Int, j::Int)
    pivot!(T::Tableau)

Modify `T` by doing a pivot operation at entry `(i,j)`.

Second version automatically finds the pivot location.
"""
function pivot!(T::Tableau, i::Int, j::Int)
    M = T.M  # for easier access

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
    pivot(T::Tableau)

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
