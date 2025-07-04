using SimplexTableaux

"""
    example1()

Sample linear program from here: https://www.youtube.com/watch?v=rzRZLGD_aeE
"""
function example1()
    A = [3 5; 4 1]
    b = [78; 36]
    c = [5; 4]
    return Tableau(A, b, c)
end

"""
    example2()

Sample linear program from here: https://www.youtube.com/watch?v=rzRZLGD_aeE
"""
function example2()
    A = [3 10 5; 5 2 8; 8 10 3]
    b = [120; 6; 105]
    c = [3; 4; 1]
    return Tableau(A, b, c)
end

function example3()
    A = [1 1 3; 2 2 5; 4 1 2]
    b = [30; 24; 36]
    c = [3; 1; 1]
    return Tableau(A, b, c)
end

function example4()
    A = [4 5; 8 5; 4 1]
    b = [60; 80; 20]
    c = [1; 1]
    return Tableau(A, b, c)
end

function example5()
    A = [8 3; 1 1; 1 4]
    b = [24; 4; 12]
    c = [2; 1]
    return T = Tableau(A, b, c)
end

function unbounded_example()
    A = [-1 0; 0 -1]
    b = [-1; -1]
    c = [1; 1]
    return Tableau(A, b, c)
end

function random_example(n_vars::Int, n_cons::Int, modulus::Int=10)
    f(x::Int) = mod1(x, modulus)
    A = f.(rand(Int, n_cons, n_vars))
    b = f.(rand(Int, n_cons))
    c = f.(rand(Int, n_vars))
    return Tableau(A, b, c)
end

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

nothing
