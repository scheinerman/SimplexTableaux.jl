using SimpleTableaux

"""
    bad()

Create a `Tableau` that `pivot_solve` can't handle. 
"""
function bad()
    A = [
        2 2 6
        3 9 8
        9 7 3
    ]
    b = [9; 1; 2]
    c = [2; 1; 4]
    return Tableau(A, b, c)
end
