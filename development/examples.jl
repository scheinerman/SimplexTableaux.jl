using SimplexTableaux, SimpleDrawing, Plots, SimpleDrawingObjects

"""
    dog_food()

A,b,c for chapter 3 dogfood problem
"""
function dog_food()
    A = [3 10; 5 6; 10 2]
    b = [100; 100; 100]
    c = [25; 10]
    return A, b, c
end

"""
    peanut_butter()

A,b,c for peanut butter manufacturing problem in chapter 3
"""
function peanut_butter()
    A = [7//10 9//10; 1//10 5//100; -1 5//10]
    b = [5000; 500; 0]
    c = [305; 545] .// 1000
    return -A, -b, -c
end

function fishkind4()
    A = [2 1 0 9 -1; 1 1 -1 5 1]
    b = [9; 7]
    c = [2; 4; 2; 1; -1]
    @info "This problem is already in standard form"
    T = Tableau(A, b, c, false)
end

"""
    small_example()

Small example for section 4.4
"""
function small_example()
    A = [3 2 -1; 1 -1 3]
    b = [1; 6]
    c = [1; 2; 3]
    return Tableau(A, b, c, false)
end

function unbounded_example()
    A = [1 2; 2 1; 0 -1]
    b = [5; 4; -3]
    c = [-1; -2]
    T = Tableau(A, b, c)
    return T
end

function unbounded_picture()
    newdraw()
    S = Segment(2.5im, 5+0im)
    set_linewidth!(S, 2)

    draw(S)

    S = Segment(2, 0, 0, 4)
    set_linewidth!(S, 2)
    draw(S)

    S = Segment(0, 3, 6, 3)
    set_linewidth!(S, 2)

    draw(S)

    draw_xaxis(-1, 6)
    draw_xtick(1:5)

    draw_yaxis(-1, 5)
    draw_ytick(1:4)

    finish()
end

function degenerate_example()
    A = [
        7 7 45 -1 3 -53 -68
        9 -5 27 -115 7 -129 42
        5 -3 63 -96 10 -109 86
    ]
    b = [26; 18; 34]
    c = [1; 7; -37; 94; -9; 76; -146]
    T = Tableau(A, b, c, false)
    set_basis!(T, [1, 3, 6])
    return T
end

nothing
