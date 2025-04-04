
> **Note**: Any version numbered 0.0.x is likely to be buggy and it just preliminary before the 0.1.0 release. 

# SimplexTableaux

This module can be used to show how to solve linear programming problems using the simplex method by pivoting
tableaux. 

This is an illusration project for solving 
feasible optimization problems of the form 
$\max c^t x$ subject to $Ax ≤ b$ and $x \ge 0$. 

## Caveats

As a demonstration project, this is not suitable for solving actual linear programming (LP) problems. 
At present it will fail if:
* The LP is infeasible.
* The LP is unbounded.
* Other unidentified reasons. (In other words, still buggy.)


This module is only set up for maximization problems only. To solve a minimization problem use the dual LP by
replacing the inputs `A`, `b`, and `c` with `A'`, `c`, and `b` respectively. 

This module solves LPs using the simplex algorithm which is not the most performant method. Further, all data is stored using arbitrary precision integers (that is, `Rational{BigInt}`) which gives exact answer, but is much slower than floating point arithmetic. These issues are negligible for small problems. 


# Quick Start Instructions

## Set up the problem

This example comes from [this video](https://www.youtube.com/watch?v=rzRZLGD_aeE).

Create the matrix `A`, the RHS vector `b`, and the objective function coefficients `c`:
```
julia> using SimplexTableaux
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

## Solve the problem 

```
julia> x = pivot_solve(T)
3×6 DataFrame
 Row │ x1     x2     s1     s2     val    RHS   
     │ Exact  Exact  Exact  Exact  Exact  Exact 
─────┼──────────────────────────────────────────
   1 │ 3      5      1      0      0      78
   2 │ 4      1      0      1      0      36
   3 │ -5     -4     0      0      1      0


Pivot at (2,1)

3×6 DataFrame
 Row │ x1     x2     s1     s2     val    RHS   
     │ Exact  Exact  Exact  Exact  Exact  Exact 
─────┼──────────────────────────────────────────
   1 │ 0      17/4   1      -3/4   0      51
   2 │ 1      1/4    0      1/4    0      9
   3 │ 0      -11/4  0      5/4    1      45


Pivot at (1,2)

3×6 DataFrame
 Row │ x1     x2     s1     s2     val    RHS   
     │ Exact  Exact  Exact  Exact  Exact  Exact 
─────┼──────────────────────────────────────────
   1 │ 0      1      4/17   -3/17  0      12
   2 │ 1      0      -1/17  5/17   0      6
   3 │ 0      0      11/17  13/17  1      78

Optimum value after 2 iterations = 78

2-element Vector{Rational{BigInt}}:
  6
 12
```


## Check the results

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

## Repeat using a proper LP solver

```
julia> lp_solve(T)
Optimum value = 78.0
2-element Vector{Float64}:
  6.0
 12.0
```

The `lp_solve` function uses the [HiGHS](https://highs.dev/) solver. 
