using SimpleTableaux

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

nothing
