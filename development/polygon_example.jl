include("points2line.jl")
using SimpleDrawing, SimpleDrawingObjects, Clines, SimplexTableaux

function my_points()
    [1+im, 5+2im, 6+3im, 5+5im, 3+5im, 2+4im]
end

function make_lines(plist)
    newdraw()
    w = 3 + 3im

    P = FilledPolygon(plist)
    set_fillcolor!(P, "lightgray")
    draw(P)

    draw_xaxis(8)
    draw_xaxis(-1)
    draw_xtick(1:7)

    draw_yaxis(7)
    draw_yaxis(-1)
    draw_ytick(1:6)

    np = length(plist)
    for i in 1:(np - 1)
        points2line(plist[i], plist[i + 1])
        points2inequality(plist[i], plist[i + 1], w)
    end
    points2line(plist[1], plist[end])
    points2inequality(plist[1], plist[end], w)

    for p in plist
        P = Point(p)
        set_pointsize!(P, 3)
        draw(P)
    end

    L = Line(0, 10, 10, 0)
    draw(L)
    L = Line(2, 0, 0, 2)
    draw(L)

    finish()
    #    np = length(plist)

end

make_lines() = make_lines(my_points())

function make_hex_Abc()
    A = [-1 4; -1 1; -2 -1; 0 -1; 1 -1; 3 -1]
    b = [3, -3, -15, -5, -2, 2]
    c = [1; 1]
    return A, b, c
end

function make_hex_tableau()
    B = [1, 2, 3, 4, 7, 8]
    T = Tableau(make_hex_Abc()...)
    set_basis!(T, B)
    return T
end