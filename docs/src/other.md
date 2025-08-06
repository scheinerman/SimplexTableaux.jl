
# Other Features

## Inspection Functions

* `basic_vector(T)` returns the vector in which the nonbasic variables have been set to zero. 
* `get_Abc(T)` returns the original matrix `A` and the vectors `b` and `c` that were the standard presentation of the linear program.
* `get_basis(T)` returns the column numbers of the current basis.
* `is_feasible(T)` returns `true` if the current basic vector is in the feasible region.
* `is_optimal(T)` returns `true` if the tableau has reached an optimal (minimal) state.
* `value(T)` returns the objective function value of the current basic vector. 

## Tableau Manipulation

### Basis pivoting

After a basis has been established, the function `basis_pivot!` can be used to modify 
the basis by specifying the column that enters the basis and the column that leaves.
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

A tableau may be manipulated by specifying a nonzero entry on which to pivot. 
The function `pivot!(T,r,c)` pivots on the entry for constraint `r` and the column `c` 
(where `c=1` corresponds to the variable `x_1`).
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
Minimal objective value = -0.14285714285714324

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
