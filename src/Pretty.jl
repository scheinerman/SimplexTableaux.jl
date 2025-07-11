# output Tableau using PrettyTables

const _yellow = Crayon(; foreground=:yellow)
const _green = Crayon(; foreground=:green, bold=true)
const _blue = Crayon(; foreground=:blue)

function _pretty_string(x::_Exact)::String
    if x isa Integer
        return string(x)
    end
    a = numerator(x)
    b = denominator(x)
    if b==1
        return string(a)
    end
    return string(a)*"/"*string(b)
end

"""
    _header1(T::Tableau)

Text for top header row.
"""
function _header1(T::Tableau)
    result = ["", "z"]
    for i in 1:T.n_vars
        push!(result, "x_$i")
    end
    push!(result, "RHS")
    return result
end

"""
    _header2(T::Tableau)

Second row of header.
"""
function _header2(T::Tableau)
    result = ["Obj Func"]
    rest = _pretty_string.(T.M[1, :])
    append!(result, rest)
    return result
end

function _header(T::Tableau)
    return (_header1(T), _header2(T))
end

function _left_column(T::Tableau)
    result = ["Obj Func"]
    for i in 1:T.n_cons
        push!(result, "Cons $i")
    end

    return ["Cons $i" for i in 1:T.n_cons]

    return result
end

function _header_colors(T::Tableau)
    result = [Crayon(), Crayon()]
    for k in 1:T.n_vars
        col = k ∈ T.B ? _green : Crayon()
        push!(result, col)
    end
    push!(result, Crayon())
    return result
end

function show(io::IO, T::Tableau)
    MM = _pretty_string.(T.M[2:end, :])
    MM = hcat(_left_column(T), MM)
    pretty_table(MM; header=_header(T), header_crayon=_header_colors(T))
end
