# Tableau struture is based on standard minimization LP:
# min c'*x st Ax ≥ b, x≥0
#
#   1 | -c^T | 0     <== single row
#  ---+------+----
#   0 |  A   | b     <== m rows

"""
Tableau(A::Matrix, b::Vector, c::Vector, canonical::Bool=true)

Create a `Tableau` data structure for the canonical form 
linear program  minimize ``c'x`` subject to ``Ax ≥ b, x ≥ 0``.

If the LP is in standard form, minimize ``c'x`` s.t. ``Ax = b, x ≥ 0``, use 
`Tableau(A, b, c, false)`.
"""
mutable struct Tableau
    M::Matrix{_Exact}     # place to hold the entire Tableau
    A::Matrix             # (original) A matrix
    b::Vector             # (original) RHS, b vector
    c::Vector             # (original) objective coefficients, c vector
    canonical::Bool       # true if constraints are ≥
    n_vars::Int           # number of variables in the LP
    n_cons::Int           # number of constraints in the LP
    B::Vector{Int}        # current basis (column indices)

    function Tableau(A::AbstractMatrix, b::Vector, c::Vector, canonical::Bool=true)
        m, n = size(A)
        if length(b) ≠ m || length(c) ≠ n
            throw(ArgumentError("Size mismatch"))
        end

        if canonical
            A, b, c = make_standard(A, b, c)
        end
        A, b = _rank_fix(A, b)

        m, n = size(A)
        top_row = hcat(1, -c', 0)
        body = hcat(zeros(Int, m), A, b)

        M = vcat(top_row, body)

        B = zeros(Int, m)  # basis is all 0s to start

        return new(M, A, b, c, canonical, n, m, B)
    end
end

"""
    make_standard(A::AbstractMatrix, b::Vector, c::Vector)

Exand the `A` matrix with an identity matrix on the right and the `b`
vector with zeros to convert a canonical LP min `c'*x` st `A*x ≥ b, x ≥ 0` into 
min `c'*x` st `A*x = b, x ≥ 0`. Returns the new matrices/vectors `A`, `b`, and `c`.
"""
function make_standard(A::AbstractMatrix, b::Vector, c::Vector)
    m, n = size(A)
    if length(b) ≠ m || length(c) ≠ n
        throw(ArgumentError("Size mismatch"))
    end
    AA = hcat(A, -Matrix(I, m, m))
    bb = b
    cc = vcat(c, zeros(Int, m))

    return AA, bb, cc
end

"""
    restore(T::Tableau)

Create a new `Tableau` based on the original data used to create `T`.

See also `restore!`.
"""
function restore(T::Tableau)
    A, b, c = get_Abc(T)

    return Tableau(A, b, c, T.canonical)
end

"""
    get_Abc(T::Tableau)

Returns a 3-tuple containing copies of the matrix `A`
and the vectors `b` and `c` used to create `T`.
"""
function get_Abc(T::Tableau)
    if T.canonical
        AA = T.A[:, 1:(T.n_vars - T.n_cons)]
        cc = T.c[1:(T.n_vars - T.n_cons)]
        bb = copy(T.b)
        return AA, bb, cc
    end

    #AA = T.A[:, 1:(T.n_vars - T.n_cons)]
    return copy(T.A), copy(T.b), copy(T.c)
end

"""
    restore!(T::Tableau)

Restore a `Tableau` based on the original data used to create it. 
"""
function restore!(T::Tableau)
    TT = restore(T)
    m, n = size(TT.M)
    for i in 1:m
        for j in 1:n
            T.M[i, j] = TT.M[i, j]
        end
    end
    T.B = zeros(Int, T.n_cons)
    return T
end

"""
    value(T::Tableau, x::Vector)

Return the value of the LP in `T` at the point `x`.

This can also be invoked as `T(x)`.
"""
function value(T::Tableau, x::Vector)
    n = T.n_vars

    if length(x) > n
        x = x[1:n]     # trim if too long
    end

    if length(x) < n   # pad if too short
        x = vcat(x, zeros(Int, n-length(x)))
    end

    return T.c' * x
end

"""
    value(T::Tableau)

Return the value of the LP at the current basic vector. 
"""
function value(T::Tableau)
    return T.M[1, end]
end

function (T::Tableau)(x::Vector)
    return value(T, x)
end

"""
    is_canonical(T::Tableau)::Bool

Return `true` if `T` was created from a canonical LP 
and return `false` if it was created from a standard LP.
"""
function is_canonical(T::Tableau)::Bool
    return T.canonical
end

"""
    rhs(T::Tableau)

Return the right-hand column of the `T`. 

## Example
For this `Tableau`
```
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```
`rhs(T)` returns the vector `[9,7]`.

"""
function rhs(T::Tableau)
    return T.M[2:end, end]
end

"""
    header(T::Tableau)

Return the header (negative reduced costs) of `T`.

## Example

For this `Tableau`
```
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```
`header(T)` returns the vector `[-2, -4, -2, -1, 1]`.
"""
function header(T::Tableau)
    return T.M[1, 2:(end - 1)]
end

function getindex(T, i, j)
    if i<0 || i>T.n_cons || j<0 || j>T.n_vars+1
        throw(error("Index [$i,$j] invalid"))
    end
    return T.M[i + 1, j + 1]
end
