using SimpleTableaux, SimpleDrawing, SimpleDrawingObjects, Plots

"""
    visualize(T::Tableau)

If `T` is a linear program in just two variables, this will (attempt to) draw 
a picture of the constraints and the optimal solution. 
"""
function visualize(T::Tableau)
    newdraw()
    if T.n_vars != 2
        @info "Can only visualize LPs with two variables"
        return finish()
    end

    x_max = 0
    y_max = 0

    for i in 1:(T.n_cons)
        a = T.A[i, 1]
        b = T.A[i, 2]
        c = T.b[i]
        x, y = _xy_intercepts(a, b, c)

        x_max = x_max > x ? x_max : x
        y_max = y_max > y ? y_max : y

        S = Segment(x + 0im, y * im)
        set_linewidth!(S, 2)
        draw(S)
    end

    p = lp_solve(T)
    P = Point(p...)
    set_pointsize!(P, 5)
    set_pointcolor!(P, :red)
    draw(P)

    draw_xaxis(x_max * 1.15)
    draw_yaxis(y_max * 1.15)

    return finish()
end

"""
    _xy_intercepts(a, b, c)

Return the `x` and `y` interscepts of the line `ax + by = c`.
"""
function _xy_intercepts(a, b, c)
    if a == 0 || b == 0
        @info "Cannot visualize vertical or horizontal lines"
        return 0, 0
    end
    x = c / a
    y = c / b
    return x, y
end

"""
    _intercepts_to_abc(x, y)

Given `x` and `y` interscepts, find the line `ax + by = c` that
has those intercepts. The parameters `x` and `y` should be `Integer` 
or `Rational`.
"""
function _intercepts_to_abc(x, y)
    c = 1//1
    a = c//x
    b = c//y

    d1 = denominator(a)
    d2 = denominator(b)
    d = lcm(d1, d2)

    a *= d
    b *= d
    c *= d

    return Int.((a, b, c))
end
