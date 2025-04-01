# SimpleTableaux

Illustration project for the optimization problem
$\max c^t x$ subject to $Ax ≤ b$.

## Construction

Start with these:
```
A = [3 5; 4 1]
b = [78; 36]
c = [5; 4]
```
Then set up the `Tableau` as follows:
```
julia> T = Tableau(A,b,c)
3×6 DataFrame
 Row │ x1     x2     s1     s2     val    RHS   
     │ Exact  Exact  Exact  Exact  Exact  Exact 
─────┼──────────────────────────────────────────
   1 │ 3      5      1      0      0      78
   2 │ 4      1      0      1      0      36
   3 │ -5     -4     0      0      1      0
```
Notice that the last row is the encoding of the objective function.

