function big_M_tableau(T::Tableau, M::Int=1000)
    A, b, c = get_Abc(T)
    m = T.n_cons
    n = T.n_vars
    bb = deepcopy(b)
    AA = deepcopy(A)

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
    big_M_solve(T::Tableau, M::Int=1000)

Solve the LP `T` using the big-M method.
"""
function big_M_solve(T::Tableau, M::Int=1000)
    TT = big_M_tableau(T, M)
    println("Solving augmented tableau")
    x = simplex_solve!(TT)

    if isnothing(x)
        return nothing
    end
    # check that artificial vars are all zero 

    arts = x[(T.n_vars + 1):end]

    if any(arts .≠ 0)
        @info "LP is possibly infeasible. Try a larger value than M = $M?"
        return nothing
    end

    x = x[1:T.n_vars]
    B = infer_basis!(T, x)
    set_basis!(T, B)
    println("\nFinal tableau\n")
    println(T)
    v = value(T)
    println("Minimial value = $v = $(Float64(v))")
    return x
end
