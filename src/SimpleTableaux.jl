module SimpleTableaux

using DataFrames
using LinearAlgebra

import DataFrames: DataFrame
import Base: show

TabEntry = Rational{BigInt}

export Tableau, find_pivot, find_pivot_column, find_pivot_row, pivot, pivot!, restore

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

        obj = [-c; zeros(Int, m); 1; 0]'

        return new(vcat(body, obj), A, b, c, n, m)
    end
end

"""
    restore(T::Tableau)

Create a new `Tableau` based on the original data used to create `T`.
"""
function restore(T::Tableau)
    return Tableau(T.A, T.b, T.C)
end

include("Exact.jl")
include("DataFrame.jl")

function show(io::IO, T::Tableau)
    df = DataFrame(T)
    return show(io, df)
end

include("Pivoting.jl")

end # module SimpleTableaux
