_vspacer() = return "{\\Large\\strut}"

function latex_form(T::Tableau)::String
    result = _latex_header(T) * _any_row(T, 1) * "\\hline \n"

    r, _ = size(T.M)
    for i in 2:r
        result *= _any_row(T, i)
    end

    result *= _footer(T)

    return result
end

function _latex_header(T::Tableau)::String
    align_ch = "r"
    align = "{" * "|" * align_ch * "|" * align_ch^T.n_vars * "|" * align_ch * "|}"
    result = "\\begin{tabular}" * align * "\\hline \n"
    result *= _vspacer() * "\$z\$ &"
    for i in 1:T.n_vars
        result *= "\$x_{$i}\$ & "
    end
    result *= "RHS \\\\\n"
end

function _any_row(T::Tableau, i::Int)::String
    result = ""
    _, c = size(T.M)
    for j in 1:c
        result *= "\$"*latex_form(T.M[i, j])*"\$"
        if j<c
            result *= " & "
        else
            result *= "\\\\"
        end
    end
    result *= "\n"
    return _vspacer()*result
end

function _footer(T::Tableau)::String
    return "\\hline \n\\end{tabular}"
end
