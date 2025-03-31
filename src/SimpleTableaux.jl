module SimpleTableaux

using DataFrames
using LinearAlgebra

import DataFrames: DataFrame

TabEntry = Rational{BigInt}

export Tableau

struct Tableau
    M::Matrix{TabEntry}
    n_vars::Int
    n_cons::Int
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

function DataFrame(T::Tableau)
    df = DataFrame()

    # Name the rows
    rownames = ["cons" * string(k) for k in 1:(T.n_cons)]
    push!(rownames, "obj")
    df[:, "Row Name"] = rownames

    # Variable columns
    for i in 1:(T.n_vars)
        col_name = "x" * string(i)
        df[:, col_name] = T.M[:, i]
    end

    # Slack columns
    for i in 1:(T.n_cons)
        col_name = "s" * string(i)
        df[:, col_name] = T.M[:, i + T.n_vars]
    end

    # Value columns
    df[:, "val"] = T.M[:, end - 1]

    # RHS 
    df[:, "RHS"] = T.M[:, end]

    return df
end

end # module SimpleTableaux
