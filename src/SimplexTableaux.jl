module SimplexTableaux

using ChooseOptimizer
using Combinatorics
using JuMP
using LatexPrint
using LinearAlgebra
using LinearAlgebraX
using PrettyTables

import Base: getindex, show
import LatexPrint: latex_form

include("Exact.jl")

export Tableau,
    basic_vector,
    big_M_solve!,
    big_M_tableau,
    check_basis,
    dual,
    dual_basic_vector,
    find_a_basis,
    find_all_bases,
    find_pivot,
    find_pivot_column,
    get_Abc,
    get_basis,
    header,
    in_dual_feasible_state,
    in_feasible_state,
    in_optimal_state,
    infer_basis!,
    is_canonical,
    is_infeasible,
    is_unbounded,
    lp_solve,
    pivot!,
    restore!,
    rhs,
    scale_row!,
    set_basis!,
    simplex_solve!,
    status,
    swap_rows!,
    value

# _phase_one_tableau,   
# _is_std_basis_vector,
# _e_vector,
# _find_e_vectors,
# old_infer_basis!

include("rank_fix.jl")
include("Tableau.jl")
include("Pivoting.jl")
include("Solver.jl")
include("LPsolve.jl")
include("lap.jl")
include("Pretty.jl")
include("Dual.jl")
include("Status.jl")
include("Bases.jl")
include("big_M.jl")

end # module SimpleTableaux
