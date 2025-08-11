using SimplexTableaux, SimpleDrawing, Plots, SimpleDrawingObjects, Clines

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
    set_basis!(T, [1, 2, 5])
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

function degenerate_example_1()
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

function degenerate_example_2()
    A = [
        3 -2
        1 -5
        -3 2
        -1 5
        1 -1
    ]

    b = [
        1
        -17
        -14
        4
        -1
    ]

    c = [1; 1]

    B = [1, 2, 3, 6, 7]

    T = Tableau(A, b, c)
    set_basis!(T, B)
    return T
end

function deg_picture()
    newdraw()

    L1 = Line(3, 4, 8, 5)
    L2 = Line(8, 5, 6, 2)
    L3 = Line(6, 2, 1, 1)
    L4 = Line(1, 1, 3, 4)
    L5 = Line(3, 4, 4, 5)

    p1 = Point(1, 1)
    p2 = Point(3, 4)
    p3 = Point(8, 5)
    p4 = Point(6, 2)
    pp = [p1, p2, p3, p4]

    draw_xaxis(-1, 9)
    draw_yaxis(-1, 6)

    draw_xtick(1:8)
    draw_ytick(1:5)

    for p in pp
        draw(p)
    end

    LL = [L1, L2, L3, L4, L5]

    for L in LL
        draw(L)
    end
    finish()
end

# from the Gass and Vinjamuri paper

function example_kuhn()
    A = [
        1 0 0 -2 -9 1 9;
        0 1 0 1//3 1 -1//3 -2;
        0 0 1 2 3 -1 -12
    ]
    b = [0; 0; 2]
    c = [0; 0; 0; -2; -3; 1; 12]

    return Tableau(A, b, c, false)
end

function example_chvatal()
    c = [10; -57; -9; -24]
    A = [
        1//2 -11//2 -5//2 9
        1//2 -3//2 -1//2 1
        1 0 0 0
    ]
    b = [0; 0; 1]
    T = Tableau(A, b, -c)
    return T
end

function phase_one_example()
    A = [5 -2 4 0 0; 5 4 -4 -4 0; 0 1 -5 -2 4]
    b = [-3, 1, -5]
    c = [5, 1, -2, -1, 1]
    return Tableau(A, b, c, false)
end

function phase_one_trouble()
    A = [5 1 3; 1 1 3]
    b = [5, 5]
    c = [0, 4, -1]
    return Tableau(A, b, c, false)
end

nothing
