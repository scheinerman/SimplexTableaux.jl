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
