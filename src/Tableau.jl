# Tableau struture is based on standard minimization LP:
# min c'*x st Ax ≥ b, x≥0
#
#   1 | -c^T | 0     <== single row
#  ---+------+----
#   0 |  A   | b     <== m rows

"""
Tableau(A::Matrix, b::Vector, c::Vector)

Create a `Tableau` data structure for the linear program minimize `c' * x` subject to `A * x ≥ b, x ≥ 0`.

If matrix and vectors are already in standard form, then use `Tableau(A, b, c, false)`.
"""
mutable struct Tableau
    M::Matrix{_Exact}     # place to hold the entire Tableau
    A::Matrix             # (original) A matrix
    b::Vector             # (original) RHS, b vector
    c::Vector             # (original) objective coefficients, c vector
    n_vars::Int           # number of variables in the LP
    n_cons::Int           # number of constraints in the LP
    B::Vector{Int}        # current basis (column indices)

    function Tableau(A::AbstractMatrix, b::Vector, c::Vector, is_cannonical::Bool=true)
        m, n = size(A)
        if length(b) ≠ m || length(c) ≠ n
            throw(ArgumentError("Size mismatch"))
        end
        A, b = _rank_fix(A, b)

        if is_cannonical
            A, b, c = make_standard(A, b, c)
        end
        m, n = size(A)
        top_row = hcat(1, -c', 0)
        body = hcat(zeros(Int, m), A, b)

        M = vcat(top_row, body)

        B = zeros(Int, m)  # basis is all 0s to start

        return new(M, A, b, c, n, m, B)
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
    return Tableau(T.A, T.b, T.c, false)
end

"""
    get_Abc(T::Tableau)

Returns a 3-tuple containing copies of the matrix `A`
and the vectors `b` and `c` used to create `T`.
"""
function get_Abc(T::Tableau)
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
"""
function value(T::Tableau, x::Vector)
    return T.c' * x
end

"""
    value(T::Tableau)

Return the value of the LP at the current basic vector. 
"""
function value(T::Tableau)
    x = basic_vector(T)
    return value(T, x)
end

function in_optimal_state(T::Tableau)
    return all(T.M[1, 2:(end - 1)] .≤ 0)
end
