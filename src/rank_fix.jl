function _rank_fix(A::AbstractMatrix, b::Vector)
    r, _ = size(A)
    M = hcat(A, b)
    if rankx(M) == r
        return A, b
    end

    # find a redundant row and remove it, then recurse

    for i in r:-1:1
        MM = vcat(M[1:(i - 1), :], M[(i + 1):end, :])
        if rankx(MM) == rankx(M)   # redundant row found 
            AA = MM[:, 1:(end - 1)]
            bb = MM[:, end]
            return _rank_fix(AA, bb)
        end
    end
    # this can't happen
end
