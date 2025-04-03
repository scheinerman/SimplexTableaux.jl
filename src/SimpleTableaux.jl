module SimpleTableaux

using ChooseOptimizer
using DataFrames
using JuMP
using LinearAlgebra
using SimpleDrawing
using SimpleDrawingObjects

import DataFrames: DataFrame
import Base: show

TabEntry = Rational{BigInt}

export Tableau,
    find_pivot,
    find_pivot_column,
    find_pivot_row,
    lp_solve,
    pivot,
    pivot!,
    pivot_solve,
    pivot_solve!,
    restore,
    restore!,
    visualize

"""
Tableau(A::Matrix, b::Vector, c::Vector)

Create a `Tableau` data structure for the linear program maximize `c'x` subject to `Ax ≤ b`.
"""
struct Tableau
    M::Matrix{TabEntry}   # place to hold the entire Tableau
    A::Matrix             # (original) A matrix
    b::Vector             # (original) RHS, b vector
    c::Vector             # (original) objective coefficients, c vector
    n_vars::Int           # number of variables in the LP
    n_cons::Int           # number of constraints in the LP

    function Tableau(A::AbstractMatrix, b::Vector, c::Vector)
        m, n = size(A)
        if length(b) ≠ m || length(c) ≠ n
            throw(ArgumentError("Size mismatch"))
        end
        body = hcat(A, Matrix(I, m, m), zeros(Int, m), b)

        obj = collect([-c; zeros(Int, m); 1; 0]')

        return new(vcat(body, obj), A, b, c, n, m)
    end
end

"""
    restore(T::Tableau)

Create a new `Tableau` based on the original data used to create `T`.

See also `restore!`.
"""
function restore(T::Tableau)
    return Tableau(T.A, T.b, T.c)
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

include("Exact.jl")
include("DataFrame.jl")

function show(io::IO, T::Tableau)
    df = DataFrame(T)
    return show(io, df)
end

include("Pivoting.jl")
include("Solver.jl")
include("LPsolve.jl")
include("Visualize.jl")

end # module SimpleTableaux
