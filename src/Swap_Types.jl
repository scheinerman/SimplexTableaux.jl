"""
    make_standard(T::Tableau)

Convert a Tableau for a canonical LP into a new, equivalent Tableau in standard form. 
"""
function make_standard(T::Tableau)
    if !is_canonical(T)
        @info "This tabelau is already in standard form"
        return T
    end

    AA, bb, cc = _make_standard(get_Abc(T)...)
    return Tableau(AA, bb, cc)
end

"""
    make_canonical(T::Tableau)

Convert a Tableau for a standard form LP into a new, equivalent Tableau in canonical form. 
"""
function make_canonical(T::Tableau)
    if is_canonical(T)
        @info "This tableau is already in canonical form"
        return T
    end
    AA, bb, cc = _make_canonical(get_Abc(T)...)
    return Tableau(AA, bb, cc, true)
end
