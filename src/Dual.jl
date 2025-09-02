"""
	dual(T::Tableau)

Create a tableau that is dual to `T`. 

Caveats:
* `T` should have been created from canonical data (not standard). [Standard LPs TBW.]
* The returned tableau is set up as a minimization problem so the value of the solved LP is negative the desired value. However, the basic feasible vector is correct.
"""
function dual(T::Tableau)::Tableau
    if is_canonical(T)
        return _canonical_dual(T)
    end
    @info "Dual of non-canonical LPs not implemented yet"
    return T
end

function _canonical_dual(T::Tableau)::Tableau
    T = deepcopy(T)
    restore!(T)
    A, b, c = T.A, T.b, T.c

    m = T.n_cons
    n = T.n_vars

    A = A[:, 1:(n - m)]

    if !iszero(c[(n - m + 1):end])
        error(msg)
    end
    c = c[1:(n - m)]

    return Tableau(-A', -c, -b)
end
