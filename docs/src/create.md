# Creating Tableaux


The `Tableau` function creates a linear programming tableau for minimization
problems presented either in canonical or standard form, as explained here. 



## Canonical LPs

A canonical LP has the form $\min c^T x$ s.t. $Ax ≥ b, x \ge 0$. 
To set up a tableau for this problem simply create the matrix `A` 
and the vectors `b` and `c`, and call `Tableau(A,b,c)`. 

For example, let `A`, `b`, and `c` be as follows:
```
julia> A = [3 10; 5 6; 10 2];

julia> b = [100, 100, 100];

julia> c = [25, 10];

julia> Tableau(A, b, c)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │ -25 │ -10 │   0 │   0 │   0 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   3 │  10 │  -1 │   0 │   0 │ 100 │
│   Cons 2 │ 0 │   5 │   6 │   0 │  -1 │   0 │ 100 │
│   Cons 3 │ 0 │  10 │   2 │   0 │   0 │  -1 │ 100 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```
Notice that extra variables $x_3$, $x_4$, and $x_5$ are added to the tableau
as slack variables to convert inequalities into equations. That is, canonical 
form LPs are automatically converted into standard form. 

## Standard LPs

A linear program in standard form is $\min c^T x$ s.t. $Ax = b$, $x ≥ 0$. 
For example,
```
julia> A = [2 1 0 9 -1; 1 1 -1 5 1]
2×5 Matrix{Int64}:
 2  1   0  9  -1
 1  1  -1  5   1

julia> b = [9, 7]
2-element Vector{Int64}:
 9
 7

julia> c = [2, 4, 2, 1, -1]
5-element Vector{Int64}:
  2
  4
  2
  1
 -1

julia> T = Tableau(A, b, c, false)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```
The fourth argument `false` means that the constraints are already equalities and slack variables should not be appended. 

