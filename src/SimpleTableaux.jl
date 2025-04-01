module SimpleTableaux

using DataFrames
using LinearAlgebra

import DataFrames: DataFrame
import Base: show

TabEntry = Rational{BigInt}

export DataFrame, Tableau
"""
Tableau(A::Matrix, b::Vector, c::Vector)

Create a `Tableau` datastructure for the linear program maximize `c'x` subject to `Ax ≤ b`.
"""
struct Tableau
    M::Matrix{TabEntry}   # place to hold the entire Tableau
    n_vars::Int           # number of variables in the LP
    n_cons::Int           # number of constraints in the LP

    function Tableau(A::Matrix, b::Vector, c::Vector)
        m, n = size(A)
        if length(b) ≠ m || length(c) ≠ n
            throw(ArgumentError("Size mismatch"))
        end
        body = hcat(A, Matrix(I, m, m), zeros(Int, m), b)

        obj = [-c; zeros(Int, m); 1; 0]'

        return new(vcat(body, obj), n, m)
    end
end

include("Exact.jl")
include("DataFrame.jl")

end # module SimpleTableaux
