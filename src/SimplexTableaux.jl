module SimplexTableaux

using ChooseOptimizer
using Combinatorics
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
    set_basis!, get_Abc, get_basis, is_feasible, lp_solve, pivot!, restore!, value

include("Tableau.jl")
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

"""
    is_feasible(T::Tableau, x::Vector)::Bool

Return `true` is the vector `x` is a in the feasible region
of the LP represented in `T`.
"""
function is_feasible(T::Tableau, x::Vector)::Bool
    return T.A*x == T.b && all(x .>= 0)
end

include("Bases.jl")

end # module SimpleTableaux
