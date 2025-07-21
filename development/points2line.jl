using LinearAlgebraX

"""
    points2line(x1::Union{Rational,Integer}, y1::Union{Rational,Integer}, x2::Union{Rational,Integer}, y2::Union{Rational,Integer})

Given points `x1,y1` and `x2,y2` return `a,b,c` such that both points satisfy `a*x + b*y = c`.
"""
function points2line(
    x1::Union{Rational,Integer},
    y1::Union{Rational,Integer},
    x2::Union{Rational,Integer},
    y2::Union{Rational,Integer},
)
    M = [x1 y1 1; x2 y2 1]
    abc = collect(nullspacex(M))
    dlist = denominator.(abc)
    d = lcm(dlist...)
    abc *= d
    if abc[1] < 0
        abc *= -1
    end
    abc[3] *= -1

    a, b, c = Int.(abc)

    return a, b, c
end

function points2line(z1, z2)
    x1, y1 = reim(z1)
    x2, y2 = reim(z2)
    return points2line(x1, y1, x2, y2)
end

"""
    points2inequality(z1, z2, w)

Print an inequality for the halfspace bounded by the line through
`z1` and `z2` that contains `w`.
"""
function points2inequality(z1, z2, w)
    a, b, c = points2line(z1, z2)

    x, y = reim(w)

    if a*x + b*y < c
        a, b, c = -a, -b, -c
    end
    println("$a*x + $b*y ≥ $c")
end
