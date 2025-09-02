module SimplexTableaux

using ChooseOptimizer
using Combinatorics
using JuMP
using LatexPrint
using LinearAlgebra
using LinearAlgebraX
using PrettyTables

import Base: show
import LatexPrint: latex_form

include("Exact.jl")

export Tableau,
    basic_vector,
    big_M_solve!,
    big_M_tableau,
    check_basis,
    dual,
    set_basis!,
    find_a_basis,
    find_all_bases,
    find_pivot,
    find_pivot_column,
    get_Abc,
    get_basis,
    in_feasible_state,
    in_optimal_state,
    infer_basis!,
    is_canonical,
    is_infeasible,
    is_unbounded,
    lp_solve,
    matrix_pivot!,
    basis_pivot!,
    restore!,
    simplex_solve!,
    swap_rows!,
    value

include("rank_fix.jl")
include("Tableau.jl")
include("Pivoting.jl")
include("Solver.jl")
include("LPsolve.jl")
include("lap.jl")
include("Pretty.jl")
include("Dual.jl")

"""
    in_feasible_state(T::Tableau)::Bool

Return `true` is the current state of `T` is at a feasible vector.
"""
function in_feasible_state(T::Tableau)::Bool
    x = basic_vector(T)
    all(x .>= 0)
end

"""
    in_feasible_state(T::Tableau, x::Vector)::Bool

Return `true` is the vector `x` is a in the feasible region
of the LP represented in `T`.
"""
function in_feasible_state(T::Tableau, x::Vector)::Bool
    return T.A*x == T.b && all(x .>= 0)
end

include("Bases.jl")
include("big_M.jl")

end # module SimpleTableaux
