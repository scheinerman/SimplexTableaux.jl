_Exact = Union{Integer,Rational}

"""
    Exact

This is a wrapper type for an `Integer` or a `Rational`.
It's only purpose is to make printing a `Tableau` as a `DataFrame` cleaner.
"""
struct Exact
    val::_Exact
    function Exact(a::_Exact)
        return new(a)
    end
end


function show(io::IO, x::Exact)
    a = numerator(x.val)
    b = denominator(x.val)
    if b==1
        print(io, a)
    else
        print(io, "$a/$b")
    end
end