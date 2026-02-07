"""
	dual(T::Tableau)

Create a tableau that is dual to `T`. 

**Note**: The returned tableau is set up as a minimization problem so the value of the solved LP is negative the desired value.
"""
function dual(T::Tableau)::Tableau
    if is_canonical(T)
        return _canonical_dual(T)
    end
    return _standard_dual(T)
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

    return Tableau(-A', -c, -b, true)
end

function dual_basic_vector(T::Tableau, B)
    A = T.A
    c = T.c
    A_B = A[:, B]
    c_B = c[B]
    yT = c_B' * invx(A_B)
    return yT'
end

"""
	dual_basic_vector(T::Tableau)

Return the dual basic vector for `T`.
"""
function dual_basic_vector(T::Tableau)
    B = get_basis(T)
    if 0 ∈ B
        error("No basis set for this tableau")
    end
    return dual_basic_vector(T, B)
end

function _standard_dual(T::Tableau)::Tableau
    A, b, c = get_Abc(T)
    AA = [A' -A']
    display(AA)
    bb = -c
    cc = [b; -b]
    return Tableau(AA, bb, cc, true)
end
