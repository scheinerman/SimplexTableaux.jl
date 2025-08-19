"""
	dual(T::Tableau)

Create a tableau that is dual to `T`. 

Caveats:
* `T` should have been created from canonical data (not standard). If not, an error is thrown.
* The returned tableau is set up as a minimization problem so the value of the solved LP is negative the desired value. However, the basic feasible vector is correct.
"""
function dual(T::Tableau)::Tableau
    msg = "Tableau not from a canonical LP"

    T = deepcopy(T)
    restore!(T)
    A, b, c = get_Abc(T)

    m = T.n_cons
    n = T.n_vars

      II = -A[:, end-m+1:end]

    if II ≠ eye(Int, m)
        error(msg)
    end
    A = A[:, 1:n-m]

    if !iszero(c[(n - m + 1):end])
        error(msg)
    end
    c = c[1:(n - m)]

    return Tableau(-A', -c, -b)
end
