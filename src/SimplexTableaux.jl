module SimplexTableaux

using ChooseOptimizer
using JuMP
using LatexPrint
using LinearAlgebra
using LinearAlgebraX
using PrettyTables

import Base: show

# function __init__()
#     LatexPrint.set_slash()
# end

include("Exact.jl")

export Tableau,
    basis_pivot,
    basis_pivot!,
    get_Abc,
    is_feasible,
    lp_solve,
    pivot,
    pivot!,
    restore,
    restore!,
    scale,
    scale!,
    swap,
    swap!

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
struct Tableau
    M::Matrix{_Exact}     # place to hold the entire Tableau
    A::Matrix             # (original) A matrix
    b::Vector             # (original) RHS, b vector
    c::Vector             # (original) objective coefficients, c vector
    n_vars::Int           # number of variables in the LP
    n_cons::Int           # number of constraints in the LP

    function Tableau(A::AbstractMatrix, b::Vector, c::Vector, is_cannonical::Bool=true)
        m, n = size(A)
        if length(b) ≠ m || length(c) ≠ n
            throw(ArgumentError("Size mismatch"))
        end

        if is_cannonical
            A, b, c = make_standard(A, b, c)
        end
        m, n = size(A)
        top_row = hcat(1, -c', 0)
        body = hcat(zeros(Int, m), A, b)

        M = vcat(top_row, body)

        # test rank of M[2:end,2:end-1]
        if rankx(M[2:end, 2:(end - 1)]) ≠ m
            @warn("Rank difficient Tableau")
        end

        return new(M, A, b, c, n, m)
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
    return T
end

include("Pivoting.jl")
include("Solver.jl")
include("LPsolve.jl")
include("lap.jl")
include("Pretty.jl")

"""
    is_feasible(T::Tableau)::Bool

Return `true` is the current state of `T` is at a feasible vector.
"""
function is_feasible(T::Tableau)::Bool
    b = T.M[2:end, end]
    all(b .>= 0)
end

end # module SimpleTableaux
