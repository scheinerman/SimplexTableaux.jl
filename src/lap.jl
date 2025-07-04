import LatexPrint.latex_form

function latex_form(T::Tableau)::String
    result = _header(T) * _any_row(T, 1) * "\\hline"

    r,_ = size(T.M)
    for i=2:r 
        result *= _any_row(T, i)
    end

    result *= _footer(T)

    return result
end

function _header(T::Tableau)::String
    align = "{c|" * "c"^T.n_vars * "|c}"
    return "\\begin{array}" * align * "\n"
end

function _any_row(T::Tableau, i::Int)::String
    result = ""
    _, c = size(T.M)
    for j in 1:c
        result *= latex_form(T.M[i, j])
        if j<c
            result *= " & "
        else
            result *= "\\\\"
        end
    end
    result *= "\n"
    return result
end

function _footer(T::Tableau)::String
    return "\\end{array}"
end
