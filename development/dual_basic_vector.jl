using SimplexTableaux, LinearAlgebraX

function dual_basic_vector(T::Tableau, B)
    A = T.A 
    c = T.c
    A_B = A[:, B]
    c_B = c[B]
    yT = c_B' * invx(A_B)
    return yT'
end

function dual_basic_vector(T::Tableau)
    B = get_basis(T)
    if 0 ∈ B
        error("No basis set for this tableau")
    end
    return dual_basic_vector(T, B)
end
