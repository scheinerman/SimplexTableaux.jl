using SimplexTableaux, LatexPrint

function canonical_example()
    A = [7 5 2 9; 5 9 5 5];
    b = [2, 5];
    c = [7, 6, 3, 4];
    T = Tableau(A, b, c)
end

function standard_example()
    A = [1 8 -2 8 6 -1; 2 6 2 9 2 1; 6 3 5 9 7 1];
    b = [-2, 4, 9];
    c = [0, 3, 3, -1, 2, -4];
    T = Tableau(A, b, c, false)
end

function standard_infeasible()
    A = [3 2 2 2 3; 4 4 3 5 2; 1 2 4 2 1]
    b = [4, 2, 1]
    c = [3, 1, 5, 2, 5]
    T = Tableau(A, b, c, false)
end
