"""
    big_M_tableau(T::Tableau, M::Int=100)

Form a new tableau from `T` by adding `m` artificial variables 
and add the terms `+M*x_i` (for each artificial variable `x_i`) to the objective function.
Then set the basis to the columns for the artifical variables.
"""
function big_M_tableau(T::Tableau, M::Int=100)
    m = T.n_cons
    n = T.n_vars
    bb = deepcopy(T.b)
    AA = deepcopy(T.A)
    c = T.c

    # ensure RHS is nonnegative
    for i in 1:m
        if bb[i] < 0
            bb[i] = -bb[i]
            AA[i, :] = -AA[i, :]
        end
    end

    # glue an identity matrix to RHS
    AA = hcat(AA, eye(Int, m))

    # create artifical c 
    cc = vcat(c, M*ones(Int, m))

    TT = Tableau(AA, bb, cc, false)

    B = collect((n + 1):(n + m))
    set_basis!(TT, B)

    return TT
end

"""
    big_M_solve!(T::Tableau, M::Int=100, verbose::Bool=true)

Solve the LP `T` using the big-M method.
"""
function big_M_solve!(T::Tableau, M::Int=100, verbose::Bool=true)
    TT = big_M_tableau(T, M)
    if verbose
        println("Solving this augmented tableau\n")
    end
    Tx = deepcopy(TT)
    restore!(Tx)
    if verbose
        println(Tx)
    end

    x = simplex_solve!(TT, verbose)

    if isnothing(x)
        return nothing
    end
    # check that artificial vars are all zero 

    arts = x[(T.n_vars + 1):end]

    if any(arts .≠ 0)
        if verbose
            @info "LP is possibly infeasible. Try a larger value than M = $M?"
        end
        return nothing
    end

    x = x[1:T.n_vars]
    B = infer_basis!(T, x)
    set_basis!(T, B)

    if is_canonical(T)
        n = T.n_vars-T.n_cons
        x = x[1:n]
    end

    if verbose
        println("\nFinal tableau\n")
        println(T)
        v = value(T)
        println("Minimal value = $v = $(Float64(v))")
    end
    return x
end
