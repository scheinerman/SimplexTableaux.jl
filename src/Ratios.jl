
"""
    _ratio_matrix(T::Tableau, col::Int)

Create a ratio matrix for column `col` of the tableau `T`. The 
result is a four-column matrix in which:
* Column 1 is just the numbers 1, 2, 3, and so on.
* Column 2 is column number `col`.
* Column 3 is the RHS.
* Column 4 are the ratios with some set to infinity if not relevant. 
"""
function _ratio_matrix(T::Tableau, col::Int)
    if !(1 ≤ col ≤ T.n_vars)
        error("Invalid column $col")
    end

    RM = zeros(Rational{BigInt}, T.n_cons, 4)
    for i in 1:T.n_cons
        RM[i, 1] = i
        a = RM[i, 2] = T[i, col]
        b = RM[i, 3] = T.M[i + 1, end]
        if a > 0 && b ≥ 0
            RM[i, 4] = b//a
        else
            RM[i, 4] = 1//0   # invalid pivot
        end
    end

    return RM
end

function _ratio_matrix_str(T::Tableau, col::Int)
    RM = _ratio_matrix(T, col)
    result = _pretty_string.(RM)
    blank = "---"

    decimals = [blank for _ in 1:T.n_cons]

    for i in 1:T.n_cons
        if RM[i, 4] ≥ 0
            decimals[i] = @sprintf "%.7f" Float64(RM[i, 4])
        end

        if RM[i, 4] == 1//0
            result[i, 4] = blank
            decimals[i] = blank
        end
    end

    (m, i) = findmin(RM[:, 4]) # get smallest ratio
    if m == 1//0
        i = 0
    end

    result = hcat(result, decimals)

    return result, i
end

"""
    ratios(T::Tableau, col::Int)

Display a table for determining a valid pivot for `T` in column `col`.
"""
function ratios(T::Tableau, col::Int)
    RMS, i = _ratio_matrix_str(T, col)

    header = ["Constraint", "Column $col", "RHS", "Ratio", "Decimal"]
    title = "Ratios for column $col headed by " * _pretty_string(T[0, col])
    sub = ""
    if T[0, col] < 0
        sub = "Invalid pivot column"
    elseif i>0
        sub = "Best pivot is in row $i"

    else
        sub = "No valid pivot: LP is unbounded"
    end

    if col ∈ T.B
        sub = "This is a basic column"
    end

    pretty_table(RMS; column_labels=header, title=title, subtitle=sub)
end
