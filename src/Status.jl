"""
    in_optimal_state(T::Tableau)::Bool

Determine if `T` has been pivoted to a global minimum state.
"""
function in_optimal_state(T::Tableau)::Bool
    return status(T) == :optimal
end

"""
    in_feasible_state(T::Tableau)::Bool

Return `true` is the current state of `T` is at a feasible vector.
"""
function in_feasible_state(T::Tableau)::Bool
    stat = status(T)
    return stat == :optimal || stat == :feasible
end

"""
    status(T::Tableau)::Symbol

Return an indicator for the status of the tableau `T` being one of:
* `:no_basis` -- no basis has been established for this tableau
* `:feasible` -- the tableau is in a feasible state, but not optimal (rhs is nonnegative).
* `:infeasible` -- the tableau is in an infeasible state (rhs contains negative values).
* `:optimal` -- the tableau has reached a global minimization point.
* `:unbounded` -- no pivots are possible; objective function can be arbitrarily negative.
"""
function status(T::Tableau)::Symbol
    # check for a basis
    if 0 ∈ T.B
        return :no_basis
    end

    # check if at optimality
    x = basic_vector(T)
    if all(header(T) .<= 0) && all(x .>= 0)
        return :optimal
    end

    # if not optimal, but feasible
    if all(x .>= 0)
        i, j = find_pivot(T)
        if i==0
            return :unbounded
        end
        return :feasible
    end

    # basic vector 
    return :infeasible
end

"""
    in_dual_feasible_state(T::Tableau)::Bool

Determine if the header of `T` is entirely nonpositive. 
"""
function in_dual_feasible_state(T::Tableau)::Bool
    header = T.M[1, 2:(end - 1)]
    return all(header .≤ 0)
end
