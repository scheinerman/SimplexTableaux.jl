"""
    DataFrame(T::Tableau)

Present a `Tableau` as a `DataFrame`.
"""
function DataFrame(T::Tableau)
    df = DataFrame()

    # Name the rows
    rownames = ["cons" * string(k) for k in 1:(T.n_cons)]
    push!(rownames, "obj")
    df[:, "Row Name"] = rownames

    # Variable columns
    for i in 1:(T.n_vars)
        col_name = "x" * string(i)
        df[:, col_name] = Exact.(T.M[:, i])
    end

    # Slack columns
    for i in 1:(T.n_cons)
        col_name = "s" * string(i)
        df[:, col_name] = Exact.(T.M[:, i + T.n_vars])
    end

    # Value columns
    df[:, "val"] = Exact.(T.M[:, end - 1])

    # RHS 
    df[:, "RHS"] = Exact.(T.M[:, end])

    return df
end
