# SimpleTableaux

Illustration project for the optimization problem
$\max c^t x$ subject to $Ax ≤ b$ and $x \ge 0$

## Quick Start

### Set up the problem

This example comes from [this video](https://www.youtube.com/watch?v=rzRZLGD_aeE).

Create the matrix `A`, the RHS vector `b`, and the objective function coefficients `c`:
```
julia> A = [3 5; 4 1];
julia> b = [78; 36];
julia> c = [5; 4];
```
Then set up the `Tableau` as follows:
```
julia> T = Tableau(A, b, c)
3×6 DataFrame
 Row │ x1     x2     s1     s2     val    RHS   
     │ Exact  Exact  Exact  Exact  Exact  Exact 
─────┼──────────────────────────────────────────
   1 │ 3      5      1      0      0      78
   2 │ 4      1      0      1      0      36
   3 │ -5     -4     0      0      1      0
```
Notice that the last row is the encoding of the objective function.

### Solve the problem 

```
julia> x = pivot_solve(T)
Iteration 0
3×6 DataFrame
 Row │ x1     x2     s1     s2     val    RHS   
     │ Exact  Exact  Exact  Exact  Exact  Exact 
─────┼──────────────────────────────────────────
   1 │ 3      5      1      0      0      78
   2 │ 4      1      0      1      0      36
   3 │ -5     -4     0      0      1      0

Iteration 1
3×6 DataFrame
 Row │ x1     x2     s1     s2     val    RHS   
     │ Exact  Exact  Exact  Exact  Exact  Exact 
─────┼──────────────────────────────────────────
   1 │ 0      17/4   1      -3/4   0      51
   2 │ 1      1/4    0      1/4    0      9
   3 │ 0      -11/4  0      5/4    1      45

Iteration 2
3×6 DataFrame
 Row │ x1     x2     s1     s2     val    RHS   
     │ Exact  Exact  Exact  Exact  Exact  Exact 
─────┼──────────────────────────────────────────
   1 │ 0      1      4/17   -3/17  0      12
   2 │ 1      0      -1/17  5/17   0      6
   3 │ 0      0      11/17  13/17  1      78

Optimum value = 78
2-element Vector{Rational{BigInt}}:
  6
 12
 ```


### Checking the results

Checking feasibility:
```
julia> A*x .<= b
2-element BitVector:
 1
 1
```

Checking value:
```
julia> c' * x == 78
true
```

### Repeat using `HiGHS` solver

```
julia> lp_solve(T)
2-element Vector{Float64}:
  6.0
 12.0
```