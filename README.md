
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

This module is set up for minimization problems only. 

This module solves [not yet!!] LPs using the simplex algorithm which is not the most performant method. 
Further, all data is stored using arbitrary precision integers (that is, `Rational{BigInt}`) which gives 
exact results, but is much slower than floating point arithmetic. These issues are negligible for small problems. 

## Overview

There are three principle steps to solving a linear program with this module:
* Create the tableau: `Tableau(A,b,c)`
* Specify a feasible basis: `set_basis!(T, B)`
* Run the simplex algorithm: `simplex_solve!(T)`

# Creating and Solving Linear Programs

## Create the Tableau

### Canonical LPs

A canonical LP has the form $\min c^T x$ s.t. $Ax ≥ b, x \ge 0$. To set up a tableau for this problem simply create the matrix `A` and the vectors `b` and `c`, and call `Tableau(A,b,c)`. 

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
form LPs are automatically converted into standard form. 

### Standard LPs

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


## Specify a Basis

Use `set_basis!(T, B)` to specify a staring basis for the tableau. Here, `B` is a list (`Vector`)
of integers specifying the columns that are in the basis. 

```
julia> set_basis!(T,[1,4,5])
┌──────────┬───┬─────┬───────┬───────┬─────┬─────┬────────┐
│          │ z │ x_1 │   x_2 │   x_3 │ x_4 │ x_5 │    RHS │
│ Obj Func │ 1 │   0 │ 220/3 │ -25/3 │   0 │   0 │ 2500/3 │
├──────────┼───┼─────┼───────┼───────┼─────┼─────┼────────┤
│   Cons 1 │ 0 │   1 │  10/3 │  -1/3 │   0 │   0 │  100/3 │
│   Cons 2 │ 0 │   0 │  32/3 │  -5/3 │   1 │   0 │  200/3 │
│   Cons 3 │ 0 │   0 │  94/3 │ -10/3 │   0 │   1 │  700/3 │
└──────────┴───┴─────┴───────┴───────┴─────┴─────┴────────┘
```
> Note: On the screen, the headings for the basis (in this case, `x_1`, `x_3`, and `x_4`) appear in green. 

### Tools to find a basis

The function `find_all_bases(T)` returns a list of all feasible bases for `T`:
```
julia> find_all_bases(T)
4-element Vector{Vector{Int64}}:
 [1, 2, 3]
 [1, 2, 5]
 [1, 4, 5]
 [2, 3, 4]
```
The function `find_a_basis(T)` returns a feasible basis for `T` (the first it finds).
```
julia> find_a_basis(T)
3-element Vector{Int64}:
 1
 2
 3
```

These are inefficient functions. We plan to change the implementation of `find_a_basis` to something more performant. 



## Perform the Simplex Algorithm

Once a tableau has been set up with a feasible basis, use `simplex_solve!(T)` to run the simplex algorithm and return solution to the LP.
```
julia> simplex_solve!(T)
Starting tableau

┌──────────┬───┬─────┬───────┬───────┬─────┬─────┬────────┐
│          │ z │ x_1 │   x_2 │   x_3 │ x_4 │ x_5 │    RHS │
│ Obj Func │ 1 │   0 │ 220/3 │ -25/3 │   0 │   0 │ 2500/3 │
├──────────┼───┼─────┼───────┼───────┼─────┼─────┼────────┤
│   Cons 1 │ 0 │   1 │  10/3 │  -1/3 │   0 │   0 │  100/3 │
│   Cons 2 │ 0 │   0 │  32/3 │  -5/3 │   1 │   0 │  200/3 │
│   Cons 3 │ 0 │   0 │  94/3 │ -10/3 │   0 │   1 │  700/3 │
└──────────┴───┴─────┴───────┴───────┴─────┴─────┴────────┘

Column 4 leaves basis and column 2 enters

┌──────────┬───┬─────┬─────┬───────┬────────┬─────┬──────┐
│          │ z │ x_1 │ x_2 │   x_3 │    x_4 │ x_5 │  RHS │
│ Obj Func │ 1 │   0 │   0 │  25/8 │  -55/8 │   0 │  375 │
├──────────┼───┼─────┼─────┼───────┼────────┼─────┼──────┤
│   Cons 1 │ 0 │   1 │   0 │  3/16 │  -5/16 │   0 │ 25/2 │
│   Cons 2 │ 0 │   0 │   1 │ -5/32 │   3/32 │   0 │ 25/4 │
│   Cons 3 │ 0 │   0 │   0 │ 25/16 │ -47/16 │   1 │ 75/2 │
└──────────┴───┴─────┴─────┴───────┴────────┴─────┴──────┘

Column 5 leaves basis and column 3 enters

┌──────────┬───┬─────┬─────┬─────┬────────┬───────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │    x_4 │   x_5 │ RHS │
│ Obj Func │ 1 │   0 │   0 │   0 │     -1 │    -2 │ 300 │
├──────────┼───┼─────┼─────┼─────┼────────┼───────┼─────┤
│   Cons 1 │ 0 │   1 │   0 │   0 │   1/25 │ -3/25 │   8 │
│   Cons 2 │ 0 │   0 │   1 │   0 │   -1/5 │  1/10 │  10 │
│   Cons 3 │ 0 │   0 │   0 │   1 │ -47/25 │ 16/25 │  24 │
└──────────┴───┴─────┴─────┴─────┴────────┴───────┴─────┘

Optimality reached
Value = 300
5-element Vector{Rational}:
  8
 10
 24
  0
  0
```





# Other Features

## Inspection Functions

* `basic_vector(T)` returns the vector in which the nonbasic variable have been set to zero. 
* `get_Abc(T)` returns the original matrix `A` and the vectors `b` and `c` that were the standard presentation of the linear program.
* `get_basis(T)` returns the column number of the current basis.
* `is_feasible(T)` returns `true` if the current basic vector is in the feasible region.
* `is_optimal(T)` returns `true` if the tableau has reached an optimal (minimal) state.
* `value(T)` returns the objective function value of the current basic vector. 

## Tableau Manipulation

### Basis pivoting

After a basis has been established, the function `basis_pivot!` can be used to modify the basis by specifying the column that enters the basis and the column that leaves.
```
julia> T
┌──────────┬───┬─────┬───────┬───────┬─────┬─────┬────────┐
│          │ z │ x_1 │   x_2 │   x_3 │ x_4 │ x_5 │    RHS │
│ Obj Func │ 1 │   0 │ 220/3 │ -25/3 │   0 │   0 │ 2500/3 │
├──────────┼───┼─────┼───────┼───────┼─────┼─────┼────────┤
│   Cons 1 │ 0 │   1 │  10/3 │  -1/3 │   0 │   0 │  100/3 │
│   Cons 2 │ 0 │   0 │  32/3 │  -5/3 │   1 │   0 │  200/3 │
│   Cons 3 │ 0 │   0 │  94/3 │ -10/3 │   0 │   1 │  700/3 │
└──────────┴───┴─────┴───────┴───────┴─────┴─────┴────────┘


julia> basis_pivot!(T,2,1)
┌──────────┬───┬───────┬─────┬───────┬─────┬─────┬─────┐
│          │ z │   x_1 │ x_2 │   x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │   -22 │   0 │    -1 │   0 │   0 │ 100 │
├──────────┼───┼───────┼─────┼───────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │  3/10 │   1 │ -1/10 │   0 │   0 │  10 │
│   Cons 2 │ 0 │ -16/5 │   0 │  -3/5 │   1 │   0 │ -40 │
│   Cons 3 │ 0 │ -47/5 │   0 │  -1/5 │   0 │   1 │ -80 │
└──────────┴───┴───────┴─────┴───────┴─────┴─────┴─────┘
```

### Matrix pivoting

A tableau may be manipulated by specifying a nonzero entry on which to pivot. The function `basis_pivot!(T,r,c)` pivots on the entry for constraint `r` and the column `c` (where `c=1` corresponds to the variable `x_1`).
```
julia> T
┌──────────┬───┬─────┬───────┬───────┬─────┬─────┬────────┐
│          │ z │ x_1 │   x_2 │   x_3 │ x_4 │ x_5 │    RHS │
│ Obj Func │ 1 │   0 │ 220/3 │ -25/3 │   0 │   0 │ 2500/3 │
├──────────┼───┼─────┼───────┼───────┼─────┼─────┼────────┤
│   Cons 1 │ 0 │   1 │  10/3 │  -1/3 │   0 │   0 │  100/3 │
│   Cons 2 │ 0 │   0 │  32/3 │  -5/3 │   1 │   0 │  200/3 │
│   Cons 3 │ 0 │   0 │  94/3 │ -10/3 │   0 │   1 │  700/3 │
└──────────┴───┴─────┴───────┴───────┴─────┴─────┴────────┘


julia> matrix_pivot!(T,3,2)
┌──────────┬───┬─────┬─────┬────────┬─────┬─────────┬──────────┐
│          │ z │ x_1 │ x_2 │    x_3 │ x_4 │     x_5 │      RHS │
│ Obj Func │ 1 │   0 │   0 │ -25/47 │   0 │ -110/47 │ 13500/47 │
├──────────┼───┼─────┼─────┼────────┼─────┼─────────┼──────────┤
│   Cons 1 │ 0 │   1 │   0 │   1/47 │   0 │   -5/47 │   400/47 │
│   Cons 2 │ 0 │   0 │   0 │ -25/47 │   1 │  -16/47 │  -600/47 │
│   Cons 3 │ 0 │   0 │   1 │  -5/47 │   0 │    3/94 │   350/47 │
└──────────┴───┴─────┴─────┴────────┴─────┴─────────┴──────────┘
```

### Return to start

The function `restore!` returns the tableau to its state when it was constructed. 
```
julia> T
┌──────────┬───┬─────┬─────┬────────┬─────┬─────────┬──────────┐
│          │ z │ x_1 │ x_2 │    x_3 │ x_4 │     x_5 │      RHS │
│ Obj Func │ 1 │   0 │   0 │ -25/47 │   0 │ -110/47 │ 13500/47 │
├──────────┼───┼─────┼─────┼────────┼─────┼─────────┼──────────┤
│   Cons 1 │ 0 │   1 │   0 │   1/47 │   0 │   -5/47 │   400/47 │
│   Cons 2 │ 0 │   0 │   0 │ -25/47 │   1 │  -16/47 │  -600/47 │
│   Cons 3 │ 0 │   0 │   1 │  -5/47 │   0 │    3/94 │   350/47 │
└──────────┴───┴─────┴─────┴────────┴─────┴─────────┴──────────┘


julia> restore!(T)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ RHS │
│ Obj Func │ 1 │ -25 │ -10 │   0 │   0 │   0 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   3 │  10 │  -1 │   0 │   0 │ 100 │
│   Cons 2 │ 0 │   5 │   6 │   0 │  -1 │   0 │ 100 │
│   Cons 3 │ 0 │  10 │   2 │   0 │   0 │  -1 │ 100 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┘
```


## Using a Numerical Solver

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


## LaTeX output

Using [LatexPrint](https://github.com/scheinerman/LatexPrint.jl) users can get the 
code for pasting into a LaTeX document.
```
julia> using LatexPrint

julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬──────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │  x_5 │ RHS │
│ Obj Func │ 1 │   0 │  -3 │  -2 │   8 │    0 │   9 │
├──────────┼───┼─────┼─────┼─────┼─────┼──────┼─────┤
│   Cons 1 │ 0 │   1 │ 1/2 │   0 │ 9/2 │ -1/2 │ 9/2 │
│   Cons 2 │ 0 │   0 │ 1/2 │  -1 │ 1/2 │  3/2 │ 5/2 │
└──────────┴───┴─────┴─────┴─────┴─────┴──────┴─────┘


julia> lap(T)
\begin{tabular}{|c|ccccc|c|}\hline 
{\Large\strut}$z$ &$x_{1}$ & $x_{2}$ & $x_{3}$ & $x_{4}$ & $x_{5}$ & RHS \\
{\Large\strut}$1$ & $0$ & $-3$ & $-2$ & $8$ & $0$ & $9$\\
\hline 
{\Large\strut}$0$ & $1$ & $\frac{1}{2}$ & $0$ & $\frac{9}{2}$ & $\frac{-1}{2}$ & $\frac{9}{2}$\\
{\Large\strut}$0$ & $0$ & $\frac{1}{2}$ & $-1$ & $\frac{1}{2}$ & $\frac{3}{2}$ & $\frac{5}{2}$\\
\hline 
\end{tabular}
```

Here is the LaTeX output:

![](tableau.png)
