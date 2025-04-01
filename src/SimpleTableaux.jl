module SimpleTableaux

using DataFrames
using LinearAlgebra

import DataFrames: DataFrame
import Base: show

TabEntry = Rational{BigInt}

export DataFrame, Tableau, get_A, get_b, get_c

"""
Tableau(A::Matrix, b::Vector, c::Vector)

Create a `Tableau` data structure for the linear program maximize `c'x` subject to `Ax ≤ b`.
"""
struct Tableau
    M::Matrix{TabEntry}   # place to hold the entire Tableau
    n_vars::Int           # number of variables in the LP
    n_cons::Int           # number of constraints in the LP

    function Tableau(A::AbstractMatrix, b::Vector, c::Vector)
        m, n = size(A)
        if length(b) ≠ m || length(c) ≠ n
            throw(ArgumentError("Size mismatch"))
        end
        body = hcat(A, Matrix(I, m, m), zeros(Int, m), b)

        obj = [-c; zeros(Int, m); 1; 0]'

        return new(vcat(body, obj), n, m)
    end
end

"""
    get_A(T::Tableau)

Return the coefficient matrix of this `Tableau`.
"""
function get_A(T::Tableau)
    return copy(T.M[1:(T.n_cons), 1:(T.n_vars)])
end

"""
    get_b(T::Tableau)

Return the RHS of this `Tableau`.
"""
function get_b(T::Tableau)
    return copy(T.M[1:(T.n_cons), end])
end

"""
    get_c(T::Tableau)

Return the objective function of this `Tableau`.
"""
function get_c(T::Tableau)
    c = T.M[end, 1:(T.n_vars)]
    return collect(-c)
end

include("Exact.jl")
include("DataFrame.jl")

function show(io::IO, T::Tableau)
    df = DataFrame(T)
    return show(io, df)
end

end # module SimpleTableaux
