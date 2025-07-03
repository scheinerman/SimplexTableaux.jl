
_show_row_labels = false

"""
    show_row_labels(x::Bool=true)

When a Tableau is printed on the screen, decide if we show row labels starting with `obj`
for the top row, and then `cons1`, `cons2`, etc. for the constraint rows. If `true`, then show. 
Initially, row labels are not shown.
"""
function show_row_labels(x::Bool=true)
    SimplexTableaux._show_row_labels = x
end

"""
    DataFrame(T::Tableau)

Present a `Tableau` as a `DataFrame`.
"""
function DataFrame(T::Tableau)
    df = DataFrame()

    _, nc = size(T.M)

    # Name the rows
    if _show_row_labels
        rownames = ["cons" * string(k) for k in 1:(T.n_cons)]
        rownames = vcat(["objective"], rownames)
        df[:, "Row Name"] = rownames
    end

    # First column
    col_name = "z"
    df[:, col_name] = Exact.(T.M[:, 1])

    # Variable columns
    for i in 2:(nc - 1)
        col_name = "x" * string(i-1)
        df[:, col_name] = Exact.(T.M[:, i])
    end

    # RHS 
    df[:, "RHS"] = Exact.(T.M[:, end])

    return df
end
