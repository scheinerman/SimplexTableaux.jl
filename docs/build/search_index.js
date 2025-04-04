var documenterSearchIndex = {"docs":
[{"location":"#SimplexTableaux","page":"SimplexTableaux","title":"SimplexTableaux","text":"","category":"section"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"This is an illustration project for solving  feasible optimization problems (Linear Programs) of the form  max c^t x subject to Ax  b and x ge 0.","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"For a quick introduction (and caveats), see the  README.","category":"page"},{"location":"#Creating-a-Tableau","page":"SimplexTableaux","title":"Creating a Tableau","text":"","category":"section"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"To set up a Tableau for the LP max c^t x subject to Ax  b and x ge 0 use Tableau(A,b,c). ","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"A = [8 3; 1 1; 1 4]\nb = [24; 4; 12]\nc = [2; 1]\nT = Tableau(A, b, c)","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"This is the result:","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"4×7 DataFrame\n Row │ x1     x2     s1     s2     s3     val    RHS   \n     │ Exact  Exact  Exact  Exact  Exact  Exact  Exact \n─────┼─────────────────────────────────────────────────\n   1 │ 8      3      1      0      0      0      24\n   2 │ 1      1      0      1      0      0      4\n   3 │ 1      4      0      0      1      0      12\n   4 │ -2     -1     0      0      0      1      0","category":"page"},{"location":"#Pivoting","page":"SimplexTableaux","title":"Pivoting","text":"","category":"section"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"The functions pivot(T,i,j) and pivot!(T,i,j) are used to peform a pivot operation at row i and column j.  The first version (pivot) returns the result of the pivot, but does not alter T.  The second version (pivot!) also performs the pivot, but modifies T.","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"The function find_pivot returns the location of the pivot operation that the simplex method would use to solve the LP.","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"julia> T\n4×7 DataFrame\n Row │ x1     x2     s1     s2     s3     val    RHS   \n     │ Exact  Exact  Exact  Exact  Exact  Exact  Exact \n─────┼─────────────────────────────────────────────────\n   1 │ 8      3      1      0      0      0      24\n   2 │ 1      1      0      1      0      0      4\n   3 │ 1      4      0      0      1      0      12\n   4 │ -2     -1     0      0      0      1      0\n\njulia> find_pivot(T)\n(1, 1)\n\njulia> pivot(T,1,1)\n4×7 DataFrame\n Row │ x1     x2     s1     s2     s3     val    RHS   \n     │ Exact  Exact  Exact  Exact  Exact  Exact  Exact \n─────┼─────────────────────────────────────────────────\n   1 │ 1      3/8    1/8    0      0      0      3\n   2 │ 0      5/8    -1/8   1      0      0      1\n   3 │ 0      29/8   -1/8   0      1      0      9\n   4 │ 0      -1/4   1/4    0      0      1      6","category":"page"},{"location":"#Solving-the-LP","page":"SimplexTableaux","title":"Solving the LP","text":"","category":"section"},{"location":"#Solution-by-pivoting","page":"SimplexTableaux","title":"Solution by pivoting","text":"","category":"section"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"The function pivot_solve produces the optimal solution to the LP. ","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"julia> pivot_solve(T)\n4×7 DataFrame\n Row │ x1     x2     s1     s2     s3     val    RHS   \n     │ Exact  Exact  Exact  Exact  Exact  Exact  Exact \n─────┼─────────────────────────────────────────────────\n   1 │ 8      3      1      0      0      0      24\n   2 │ 1      1      0      1      0      0      4\n   3 │ 1      4      0      0      1      0      12\n   4 │ -2     -1     0      0      0      1      0\n\n\nPivot at (1,1)\n\n4×7 DataFrame\n Row │ x1     x2     s1     s2     s3     val    RHS   \n     │ Exact  Exact  Exact  Exact  Exact  Exact  Exact \n─────┼─────────────────────────────────────────────────\n   1 │ 1      3/8    1/8    0      0      0      3\n   2 │ 0      5/8    -1/8   1      0      0      1\n   3 │ 0      29/8   -1/8   0      1      0      9\n   4 │ 0      -1/4   1/4    0      0      1      6\n\n\nPivot at (2,2)\n\n4×7 DataFrame\n Row │ x1     x2     s1     s2     s3     val    RHS   \n     │ Exact  Exact  Exact  Exact  Exact  Exact  Exact \n─────┼─────────────────────────────────────────────────\n   1 │ 1      0      1/5    -3/5   0      0      12/5\n   2 │ 0      1      -1/5   8/5    0      0      8/5\n   3 │ 0      0      3/5    -29/5  1      0      16/5\n   4 │ 0      0      1/5    2/5    0      1      32/5\n\nOptimum value after 2 iterations = 32/5\n2-element Vector{Rational{BigInt}}:\n 12//5\n  8//5","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"To supress the illustrative output and just present the solution, use pivot_solve(T, false).","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"The alternative pivot_solve! performs the same operations as pivot_solve but modifies T as it goes.","category":"page"},{"location":"#Solution-by-use-of-an-LP-solver","page":"SimplexTableaux","title":"Solution by use of an LP solver","text":"","category":"section"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"The function lp_solve also solves the LP, but uses a standard solver (by default, HiGHS):","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"julia> lp_solve(T)\n2-element Vector{Float64}:\n 2.4000000000000004\n 1.599999999999999","category":"page"},{"location":"#The-restore!-Function","page":"SimplexTableaux","title":"The restore! Function","text":"","category":"section"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"As mentioned, the pivot! and pivot_solve! functions modify the Tableau. Use restore! to return a Tableau to its original state like this: restore!(T). ","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"There is also restore(T) which does not reset T, but creates a new Tableau equal to the original state of T.","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"julia> T\n4×7 DataFrame\n Row │ x1     x2     s1     s2     s3     val    RHS   \n     │ Exact  Exact  Exact  Exact  Exact  Exact  Exact \n─────┼─────────────────────────────────────────────────\n   1 │ 8      3      1      0      0      0      24\n   2 │ 1      1      0      1      0      0      4\n   3 │ 1      4      0      0      1      0      12\n   4 │ -2     -1     0      0      0      1      0\n\njulia> pivot!(T,1,1);\n\njulia> T\n4×7 DataFrame\n Row │ x1     x2     s1     s2     s3     val    RHS   \n     │ Exact  Exact  Exact  Exact  Exact  Exact  Exact \n─────┼─────────────────────────────────────────────────\n   1 │ 1      3/8    1/8    0      0      0      3\n   2 │ 0      5/8    -1/8   1      0      0      1\n   3 │ 0      29/8   -1/8   0      1      0      9\n   4 │ 0      -1/4   1/4    0      0      1      6\n\njulia> restore!(T)\n4×7 DataFrame\n Row │ x1     x2     s1     s2     s3     val    RHS   \n     │ Exact  Exact  Exact  Exact  Exact  Exact  Exact \n─────┼─────────────────────────────────────────────────\n   1 │ 8      3      1/5    -3/5   0      0      12/5\n   2 │ 1      1      -1/5   8/5    0      0      8/5\n   3 │ 1      4      3/5    -29/5  1      0      16/5\n   4 │ 0      0      1/5    2/5    0      1      32/5","category":"page"},{"location":"#Visualization","page":"SimplexTableaux","title":"Visualization","text":"","category":"section"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"For LPs with exactly two variables, the visualize function creates a plot of the  constraints as lines that bound the feasible region and the solution (as a dot).","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"julia> visualize(T)","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"(Image: )","category":"page"},{"location":"#Changing-the-Display-Format","page":"SimplexTableaux","title":"Changing the Display Format","text":"","category":"section"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"The usual way a Tableau is printed looks like this:","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"4×7 DataFrame\n Row │ x1     x2     s1     s2     s3     val    RHS   \n     │ Exact  Exact  Exact  Exact  Exact  Exact  Exact \n─────┼─────────────────────────────────────────────────\n   1 │ 8      3      1      0      0      0      24\n   2 │ 1      1      0      1      0      0      4\n   3 │ 1      4      0      0      1      0      12\n   4 │ -2     -1     0      0      0      1      0","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"The column headings are (should be) self-explanatory. As usual we begin with the LP variables, x_1, x_2, and so forth (rendered as x1, x2, etc.), and then the slack variables, and the right hand side. There are no row labels. To remedy that, set the (nonexported) variable SimpleTableaux.show_row_labels to true.","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"julia> SimpleTableaux.show_row_labels=true;\n\njulia> T\n4×8 DataFrame\n Row │ Row Name  x1     x2     s1     s2     s3     val    RHS   \n     │ String    Exact  Exact  Exact  Exact  Exact  Exact  Exact \n─────┼───────────────────────────────────────────────────────────\n   1 │ cons1     8      3      1      0      0      0      24\n   2 │ cons2     1      1      0      1      0      0      4\n   3 │ cons3     1      4      0      0      1      0      12\n   4 │ obj       -2     -1     0      0      0      1      0","category":"page"},{"location":"","page":"SimplexTableaux","title":"SimplexTableaux","text":"We now see that rows 1, 2, and 3 correspond to constraints and row 4 to the objective function. ","category":"page"}]
}
