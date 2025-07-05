
> **Note**: This is early days for this module. Anything before 0.1.0 is subject to massive changes. 

# SimplexTableaux

This module can be used to show how to solve linear programming problems using 
the simplex method by pivoting tableaux. 

This is an illusration project for solving  feasible optimization problems of the form 
$\min c^T x$ subject to $Ax ≥ b$ and $x \ge 0$ (canonical form)
and of the form $\min c^T x$ subject to $Ax = b$ and $x \ge 0$ (standard form).

## Caveats

As a demonstration project, this is not suitable for solving actual linear programming (LP) problems. 
At present it will fail if:
* The LP is infeasible.
* The LP is unbounded.
* Other unidentified reasons. (In other words, still buggy.)

This module is only set up for minimization problems only. 

This module solves LPs using the simplex algorithm which is not the most performant method. 
Further, all data is stored using arbitrary precision integers (that is, `Rational{BigInt}`) which gives 
exact answer, but is much slower than floating point arithmetic. These issues are negligible for small problems. 

# Setting up a `Tableau`

## Canonical form LPs

A linear program in canonical form is $\min c^T x$ s.t. $Ax ≥ b$, $x ≥ 0$. 

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
Notice that extra variables $x_3$, $x_4$, and $x_5$ are added to the `Tableau` 
as slack variables to convert inequalities into equations. That is, canonical 
from LPs are automatically converted into standard form. 



## Standard form LPs

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

# Operations

Operations on a `Tableau` may include row and/or column indices. A row index refers
to the constraint number. That is, row 1 corresponds to the `Cons 1` row. A column index refers 
to a decision variable. That is, column 1 corresonds to the $x_1$ column. 

## Pivot operations 

### Basic pivot

Use `pivot!(T, i, j)` to perform a pivot on row `i` and contraint `j`. The entry at that 
location must not be `0`.
```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘

julia> pivot!(T,1,4)
┌──────────┬───┬───────┬───────┬─────┬─────┬──────┬─────┐
│          │ z │   x_1 │   x_2 │ x_3 │ x_4 │  x_5 │ RHS │
│ Obj Func │ 1 │ -16/9 │ -35/9 │  -2 │   0 │  8/9 │   1 │
├──────────┼───┼───────┼───────┼─────┼─────┼──────┼─────┤
│   Cons 1 │ 0 │   2/9 │   1/9 │   0 │   1 │ -1/9 │   1 │
│   Cons 2 │ 0 │  -1/9 │   4/9 │  -1 │   0 │ 14/9 │   2 │
└──────────┴───┴───────┴───────┴─────┴─────┴──────┴─────┘
```
The function `pivot` has works the same, but does not modify the `Tableau`. It returns a 
copy with the result of the pivot.

### Basis pivot

Let `B` be a list of columns (with as many columns specified as there are constraints).
`basis_pivot!(T, B)` makes that selection of columns into basic variables.
```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘

julia> B = [3,5];

julia> basis_pivot!(T, B)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -6 │  -7 │   0 │ -20 │   0 │ -23 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │  -3 │  -2 │   1 │ -14 │   0 │ -16 │
│   Cons 2 │ 0 │  -2 │  -1 │   0 │  -9 │   1 │  -9 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```


## Other operations

### Swap rows

Use `swap!(T, i, j)` to swap rows `i` and `j` of the `Tableau`.
```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘

julia> swap!(T, 1, 2)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
│   Cons 2 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```

### Negating a row 

Use `negate!(T, i)` to negate row `i`. 
```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘

julia> negate!(T,2)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │  -1 │  -1 │   1 │  -5 │  -1 │  -7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```

### Return to start

Use `restore!(T)` to return `T` to its original values. 
```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘

julia> pivot!(T,2,4)
┌──────────┬───┬──────┬───────┬───────┬─────┬───────┬───────┐
│          │ z │  x_1 │   x_2 │   x_3 │ x_4 │   x_5 │   RHS │
│ Obj Func │ 1 │ -9/5 │ -19/5 │ -11/5 │   0 │   6/5 │   7/5 │
├──────────┼───┼──────┼───────┼───────┼─────┼───────┼───────┤
│   Cons 1 │ 0 │  1/5 │  -4/5 │   9/5 │   0 │ -14/5 │ -18/5 │
│   Cons 2 │ 0 │  1/5 │   1/5 │  -1/5 │   1 │   1/5 │   7/5 │
└──────────┴───┴──────┴───────┴───────┴─────┴───────┴───────┘

julia> restore!(T)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```

# Solving Linear Programs

## Manually

User can use `pivot!` to emulate the Simple Algorithm. We plan to automate this, but 
that will take a bit of time.

## Feasible basic vector

Assuming the `Tableau` has been pivoted to a basic vector, check that the current 
state is feasible (i.e., the RHS for all the constraints is non-negative).

```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘

julia> basis_pivot!(T,[2,4])
┌──────────┬───┬───────┬─────┬───────┬─────┬──────┬──────┐
│          │ z │   x_1 │ x_2 │   x_3 │ x_4 │  x_5 │  RHS │
│ Obj Func │ 1 │ -11/4 │   0 │ -43/4 │   0 │ 29/2 │ 37/2 │
├──────────┼───┼───────┼─────┼───────┼─────┼──────┼──────┤
│   Cons 1 │ 0 │  -1/4 │   1 │  -9/4 │   0 │  7/2 │  9/2 │
│   Cons 2 │ 0 │   1/4 │   0 │   1/4 │   1 │ -1/2 │  1/2 │
└──────────┴───┴───────┴─────┴───────┴─────┴──────┴──────┘

julia> is_feasible(T)
true

julia> basis_pivot!(T,[1,3])
┌──────────┬───┬─────┬──────┬─────┬──────┬──────┬──────┐
│          │ z │ x_1 │  x_2 │ x_3 │  x_4 │  x_5 │  RHS │
│ Obj Func │ 1 │   0 │   -4 │   0 │    7 │   -3 │    4 │
├──────────┼───┼─────┼──────┼─────┼──────┼──────┼──────┤
│   Cons 1 │ 0 │   1 │  1/2 │   0 │  9/2 │ -1/2 │  9/2 │
│   Cons 2 │ 0 │   0 │ -1/2 │   1 │ -1/2 │ -3/2 │ -5/2 │
└──────────┴───┴─────┴──────┴─────┴──────┴──────┴──────┘

julia> is_feasible(T)
false
```



## Using a solver

The function `lp_solve` finds a numerical solution to the linear program 
using a Julia solver (default: HiGHS).

```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘

julia> lp_solve(T)
Optimum value = -0.14285714285714324

5-element Vector{Float64}:
 0.0
 0.0
 0.0
 1.1428571428571428
 1.285714285714286
```


# LaTeX output

Using [LatexPrint](https://github.com/scheinerman/LatexPrint.jl) users can get the 
code for pasting into a LaTeX document.
```
julia> using LatexPrint

julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │  -2 │  -4 │  -2 │  -1 │   1 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   2 │   1 │   0 │   9 │  -1 │   9 │
│   Cons 2 │ 0 │   1 │   1 │  -1 │   5 │   1 │   7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘

julia> laprintln(T)

\begin{array}{r|rrrrr|r}
1 & -2 & -4 & -2 & -1 & 1 & 0\\
\hline 
0 & 2 & 1 & 0 & 9 & -1 & 9\\
0 & 1 & 1 & -1 & 5 & 1 & 7\\
\end{array}
```

![](tableau.png)