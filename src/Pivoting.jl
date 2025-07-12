_not_row_one = "May not modify the header row of the Tableau"
_not_col_one = "May not modify the z column of the Tableau"

"""
    old_pivot!(T::Tableau, i::Int, j::Int)

Modify `T` by doing a pivot operation at contraint `i` 
and variable x_`j`.
"""
function old_pivot!(T::Tableau, i::Int, j::Int)
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
    set_basis!(T::Tableau, vars::Vector{Int})

Pivot `T` so that the variables specified in `vars`
are the basic variables. 
"""
function set_basis!(T::Tableau, vars::Vector{Int})
    n = T.n_vars
    m = T.n_cons

    vars = sort(unique(vars))

    if (length(vars) ≠ m) || !(vars ⊆ collect(1:n))
        error("Invalid basis: $vars")
    end

    # bop up indices by 1 and make a list
    idx = [j+1 for j in vars]
    idx = vcat(1, idx)

    B = T.M[:, idx]
    BB = invx(B)  # will fail if B is not invertible
    T.M = BB*T.M
    T.B = vars
    return T
end

"""
    get_basis(T::Tableau)

Return the current basis (indices of basic variables).
"""
get_basis(T::Tableau) = copy(T.B)

"""
    pivot!(T::Tableau, enter::Int, leave::Int)

Remove element `leave` from the basis and include element `enter`.
"""
function pivot!(T::Tableau, enter::Int, leave::Int)
    B = Set(get_basis(T))

    # check for validity
    if 0 ∈ B
        error("No basis has been established for this tableau")
    end

    n = T.n_vars
    if !(1 ≤ leave ≤ n)
        error("Invalid variable index: $leave")
    end

    if !(1 ≤ enter ≤ n)
        error("Invalid variable index: $enter")
    end

    if leave == enter
        @warn "No pivot: enter = leave = $enter"
        return nothing
    end

    # form new basis
    B = Set(get_basis(T))
    if leave ∉ B
        error("Element $leave is not in the basis; cannot remove it")
    end
    if enter ∈ B
        error("Element $enter is already in the basis; cannot add it")
    end

    delete!(B, leave)
    push!(B, enter)
    set_basis!(T, collect(B))
end
