_not_row_one = "May not modify the header row of the Tableau"
_not_col_one = "May not modify the z column of the Tableau"

"""
    matrix_pivot!(T::Tableau, i::Int, j::Int)

Modify `T` by doing a pivot operation at contraint `i` 
and variable x_`j`.
"""
function matrix_pivot!(T::Tableau, i::Int, j::Int)
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

    vars = sort(unique(vars))

    if (length(vars) ≠ m) || !(vars ⊆ collect(1:n))
        error("Invalid basis: $vars")
    end

    # bop up indices by 1 and make a list
    idx = [j+1 for j in vars]
    idx = vcat(1, idx)

    B = T.M[:, idx]
    if detx(B) == 0
        @warn "Columns $vars do not form a basis; ignoring"
        return T
    end

    BB = invx(B)  # will fail if B is not invertible
    T.M = BB*T.M
    T.B = vars
    return T
end

"""
    check_basis(T::Tableau, vars::Vector{Int})::Bool

See if the list of column indices `vars` form a basis (feasible or not) for `T`.
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
    infer_basis!(T::Tableau)

Determine the basic variables by seeing which columns in the tableau 
are standard basis vectors. Reset the stored basis in `T` to that result,
or set the stored basis to all zeros if no basis can be inferred. 
"""
function infer_basis!(T::Tableau)
    indicators = [_is_std_basis_vector(T.M[2:end, j + 1]) for j in 1:T.n_vars]
    newB = findall(indicators)
    if length(newB) ≠ T.n_cons
        T.B = zeros(Int, T.n_cons)
        return T.B
    end
    T.B = newB
end

"""
    infer_basis!(T::Tableau, x::Vector)

When `x` is a basic feasbile vector for `T`, determine a basis 
of columns to that effect.
"""
function infer_basis!(T::Tableau, x::Vector)
    n = T.n_vars
    m = T.n_cons
    A, b, c = get_Abc(T)
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
