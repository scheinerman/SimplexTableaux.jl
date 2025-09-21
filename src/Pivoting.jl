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
    infer_basis!(T)
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

    indices = (unique(vars))

    if (length(indices) ≠ m) || !(indices ⊆ collect(1:n))
        @info "Invalid basis: $vars; ignoring."
        return T
    end

    # bop up indices by 1 and make a list
    idx = [j+1 for j in indices]
    idx = vcat(1, idx)

    B = T.M[:, idx]
    if detx(B) == 0
        @info "Columns $indices do not form a basis; ignoring"
        return T
    end

    BB = invx(B)  # will fail if B is not invertible
    T.M = BB*T.M
    T.B = indices
    return T
end

"""
    set_basis!(T::Tableau)

Invoke `find_a_basis(T)` and use the result to establish a basis for `T`.
Silently fail if no basis is found. 
"""
function set_basis!(T::Tableau)
    B = find_a_basis(T, false)
    if 0 ∉ B
        set_basis!(T, B)
    end
end

"""
    check_basis(T::Tableau, vars::Vector{Int})::Bool

See if the list of column indices `vars` forms a basis (feasible or not) for `T`.
"""
function check_basis(T::Tableau, vars::Vector{Int})::Bool
    n = T.n_vars
    m = T.n_cons

    vars = sort(unique(vars))

    if (length(vars) ≠ m) || !(vars ⊆ collect(1:n))
        return false
    end

    # bop up indices by 1 and make a list
    idx = [j+1 for j in vars]
    idx = vcat(1, idx)

    B = T.M[:, idx]
    return detx(B) ≠ 0
end

"""
    get_basis(T::Tableau)

Return the current basis (indices of basic variables).
"""
get_basis(T::Tableau) = copy(T.B)

"""
    basis_pivot!(T::Tableau, enter::Int, leave::Int)

Remove element `leave` from the basis and include element `enter`.
"""
function basis_pivot!(T::Tableau, enter::Int, leave::Int)
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

"""
    _is_std_basis_vector(v::Vector)::Bool

Return `true` is `v` is a standard basis vector (single 1, rest 0s).
"""
function _is_std_basis_vector(v::Vector)::Bool
    if !all(x==0 || x==1 for x in v)   # must be all 0s and 1s
        return false
    end
    if sum(v) ≠ 1       # must have a single 1
        return false
    end
    return true
end

"""
    old_infer_basis!(T::Tableau)

Determine the basic variables by seeing which columns in the tableau 
are standard basis vectors. Reset the stored basis in `T` to that result,
or set the stored basis to all zeros if no basis can be inferred. 
"""
function old_infer_basis!(T::Tableau)
    indicators = [_is_std_basis_vector(T.M[2:end, j + 1]) for j in 1:T.n_vars]
    newB = findall(indicators)
    if length(newB) ≠ T.n_cons
        T.B = zeros(Int, T.n_cons)
        return T.B
    end
    T.B = newB
end

"""
    swap_rows!(T::Tableau, i::Int, j::Int)

Swap constraint rows `i` and `j` in the tableau `T`.
"""
function swap_rows!(T::Tableau, i::Int, j::Int)
    if (i > T.n_cons||i < 1) || (j > T.n_cons||j < 1)
        @info "Bad row number(s) $i and/or $j; must be between 1 and $(T.n_cons). No swap performed."
        return T
    end

    if i==j
        return T
    end

    i += 1
    j += 1

    tmp = T.M[i, :]
    T.M[i, :] = T.M[j, :]
    T.M[j, :] = tmp

    return T
end

"""
    scale_row!(T::Tableau, i::Int, m::_Exact)

Modify `T` by multiplying row `i` (the `i`-th constraint) by `m`. 
"""
function scale_row!(T::Tableau, i::Int, m::_Exact)
    if i<1 || i>T.n_cons
        throw(error("Bad row index, $i"))
    end

    if m==0
        throw(error("Cannot scale a row by zero"))
    end

    T.M[i + 1, :] *= m
    infer_basis!(T)
    return T
end

"""
    _e_vector(n::Int, i::Int)

Return an elementary vector of length `n` that is all zeros 
except entry `i` which is a `1`.
"""
function _e_vector(n::Int, i::Int)
    v = zeros(Int, n)
    v[i] = 1
    return v
end

"""
    _find_e_vectors(M::Matrix, i::Int)

Return the column index `j` such that `M[:,j] == _e_vector(n,i)`.
"""
function _find_e_vectors(M::Matrix, i::Int)
    r, c = size(M)
    ei = _e_vector(r, i)
    for j in c:-1:1
        if M[:, j] == ei
            return j
        end
    end
    return 0  # not found
end

"""
    _find_e_vectors(M::Matrix)

Find (one each) the elementary column vectors. 
"""
function _find_e_vectors(M::Matrix)
    r, c = size(M)
    return [_find_e_vectors(M, i) for i in 1:r]
end

"""
    infer_basis!(T::Tableau)

Find the columns that form an elementary basis in `T` and assign that basis to `T`
"""
function infer_basis!(T::Tableau)
    M = T.M[:, 1:(end - 1)]   # don't include RHS column
    indices = _find_e_vectors(M)
    # drop artificial column 1, and subtract 1 to get proper indexing
    if length(indices) < 2
        return Int[]
    end
    B = indices[2:end] .- 1

    if any(B .< 1) || length(B) != T.n_cons
        @info "Unable to infer basis"
    else
        set_basis!(T, B)
    end
end

"""
    infer_basis!(T::Tableau, x::Vector)

When `x` is a basic feasbile vector for `T`, determine a basis 
of columns to that effect.
"""
function infer_basis!(T::Tableau, x::Vector)
    n = T.n_vars
    m = T.n_cons
    A = T.A

    B = findall(!iszero, x)

    if length(B) == m
        return B
    end

    for j in 1:n
        AA = A[:, B]
        aj = A[:, j] # column j 
        if rankx(AA) < rankx(hcat(AA, aj))
            push!(B, j)
        end
    end
    return sort(B)
end
