"""
    lp_solve(T::Tableau, verbose::Bool=true)

Use a standard linear programming solver [HiGHS by defaut] to find the optimal solution to the
LP in `T`. Returns the values of the variables. 

With `verbose` set to `true` [default], the value of the objective function is printed. Set `verbose`
to `false` to supress this. 
"""
function lp_solve(T::Tableau, verbose::Bool=true)
    MOD = Model(get_solver())
    @variable(MOD, x[1:(T.n_vars)] >= 0)
    @objective(MOD, Max, sum(T.c[i] * x[i] for i in 1:(T.n_vars)))
    for i in 1:(T.n_cons)
        @constraint(MOD, sum(T.A[i, j] * x[j] for j in 1:(T.n_vars)) <= T.b[i])
    end

    optimize!(MOD)
    status = Int(termination_status(MOD))

    if status ≠ 1
        error("Linear program is either infeasible or unbounded. Status = $status")
    end
    if verbose
        obj_val = objective_value(MOD)
        println("Optimum value = $obj_val")
    end

    xval = value.(x)

    return xval
end
