# Solving Linear Programs


## Manual Solution

Once a tableau has been created for a given linear program, the objective function can be minimized by the following steps:
* Set a starting basis using `set_basis!(T, B)`. To have the computer suggest a starting basis, use `find_a_basis(T)`. 
* Repeatedly pivot the tableau until all the numbers under variable names are nonpositive. Use `find_pivot` to have the computer suggest a basis pivot. 
* When pivoting is finished, use `basic_vector(T)` to get the values for the variables that minimizes the LP and use `value(T)` to get the minimum objective value. 





## Simplex Method Solution

Given a tableau, use `simplex_solve!` to have the computer perform all the steps to produce an optimal solution to a linear program. 

```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ RHS │
│ Obj Func │ 1 │   7 │   4 │   3 │   1 │   3 │  -8 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   6 │   5 │   8 │   0 │  -5 │   4 │   7 │
│   Cons 2 │ 0 │   3 │  -1 │  -8 │  -7 │  -2 │  -4 │   2 │
│   Cons 3 │ 0 │   1 │   7 │  -4 │  -5 │   0 │   5 │   4 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘


julia> simplex_solve!(T)
Starting basis found: [1, 2, 5]
Starting tableau

┌──────────┬───┬─────┬─────┬────────┬───────┬─────┬─────────┬───────┐
│          │ z │ x_1 │ x_2 │    x_3 │   x_4 │ x_5 │     x_6 │   RHS │
│ Obj Func │ 1 │   0 │   0 │  397/3 │ 274/3 │   0 │    65/3 │ -25/3 │
├──────────┼───┼─────┼─────┼────────┼───────┼─────┼─────────┼───────┤
│   Cons 1 │ 0 │   1 │   0 │ -113/9 │ -80/9 │   0 │ -121/36 │   8/9 │
│   Cons 2 │ 0 │   0 │   1 │   11/9 │   5/9 │   0 │   43/36 │   4/9 │
│   Cons 3 │ 0 │   0 │   0 │ -139/9 │ -91/9 │   1 │ -131/36 │   1/9 │
└──────────┴───┴─────┴─────┴────────┴───────┴─────┴─────────┴───────┘

Pivot 1: column 2 leaves basis and column 3 enters

┌──────────┬───┬─────┬──────────┬─────┬────────┬─────┬──────────┬─────────┐
│          │ z │ x_1 │      x_2 │ x_3 │    x_4 │ x_5 │      x_6 │     RHS │
│ Obj Func │ 1 │   0 │ -1191/11 │   0 │ 343/11 │   0 │ -4737/44 │ -621/11 │
├──────────┼───┼─────┼──────────┼─────┼────────┼─────┼──────────┼─────────┤
│   Cons 1 │ 0 │   1 │   113/11 │   0 │ -35/11 │   0 │    98/11 │   60/11 │
│   Cons 2 │ 0 │   0 │     9/11 │   1 │   5/11 │   0 │    43/44 │    4/11 │
│   Cons 3 │ 0 │   0 │   139/11 │   0 │ -34/11 │   1 │   126/11 │   63/11 │
└──────────┴───┴─────┴──────────┴─────┴────────┴─────┴──────────┴─────────┘

Pivot 2: column 3 leaves basis and column 4 enters

┌──────────┬───┬─────┬────────┬────────┬─────┬─────┬──────────┬────────┐
│          │ z │ x_1 │    x_2 │    x_3 │ x_4 │ x_5 │      x_6 │    RHS │
│ Obj Func │ 1 │   0 │ -822/5 │ -343/5 │   0 │   0 │ -1747/10 │ -407/5 │
├──────────┼───┼─────┼────────┼────────┼─────┼─────┼──────────┼────────┤
│   Cons 1 │ 0 │   1 │     16 │      7 │   0 │   0 │     63/4 │      8 │
│   Cons 2 │ 0 │   0 │    9/5 │   11/5 │   1 │   0 │    43/20 │    4/5 │
│   Cons 3 │ 0 │   0 │   91/5 │   34/5 │   0 │   1 │   181/10 │   41/5 │
└──────────┴───┴─────┴────────┴────────┴─────┴─────┴──────────┴────────┘

Optimality reached. Pivot count = 2
Minimal value = -407/5 = -81.4
6-element Vector{Rational}:
   8
   0
   0
  4//5
 41//5
   0
```


## Big-M Solution

The function `big_M_solution` solves linear programs using the Simplex Method on an augmented tableau. The user may specify the value of `M` or use the default (100).

```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ RHS │
│ Obj Func │ 1 │   1 │   8 │  -8 │  -8 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │  -8 │  -6 │   6 │   3 │  -8 │
│   Cons 2 │ 0 │   6 │  -8 │   1 │  -3 │  -1 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┘


julia> big_M_solve(T)
Solving this augmented tableau
┌──────────┬───┬─────┬─────┬─────┬─────┬──────┬──────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │  x_5 │  x_6 │ RHS │
│ Obj Func │ 1 │   1 │   8 │  -8 │  -8 │ -100 │ -100 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼──────┼──────┼─────┤
│   Cons 1 │ 0 │   8 │   6 │  -6 │  -3 │    1 │    0 │   8 │
│   Cons 2 │ 0 │  -6 │   8 │  -1 │   3 │    0 │    1 │   1 │
└──────────┴───┴─────┴─────┴─────┴─────┴──────┴──────┴─────┘

Starting tableau

┌──────────┬───┬─────┬──────┬──────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │  x_2 │  x_3 │ x_4 │ x_5 │ x_6 │ RHS │
│ Obj Func │ 1 │ 201 │ 1408 │ -708 │  -8 │   0 │   0 │ 900 │
├──────────┼───┼─────┼──────┼──────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │   8 │    6 │   -6 │  -3 │   1 │   0 │   8 │
│   Cons 2 │ 0 │  -6 │    8 │   -1 │   3 │   0 │   1 │   1 │
└──────────┴───┴─────┴──────┴──────┴─────┴─────┴─────┴─────┘

Pivot 1: column 6 leaves basis and column 2 enters

┌──────────┬───┬──────┬─────┬───────┬───────┬─────┬──────┬──────┐
│          │ z │  x_1 │ x_2 │   x_3 │   x_4 │ x_5 │  x_6 │  RHS │
│ Obj Func │ 1 │ 1257 │   0 │  -532 │  -536 │   0 │ -176 │  724 │
├──────────┼───┼──────┼─────┼───────┼───────┼─────┼──────┼──────┤
│   Cons 1 │ 0 │ -3/4 │   1 │  -1/8 │   3/8 │   0 │  1/8 │  1/8 │
│   Cons 2 │ 0 │ 25/2 │   0 │ -21/4 │ -21/4 │   1 │ -3/4 │ 29/4 │
└──────────┴───┴──────┴─────┴───────┴───────┴─────┴──────┴──────┘

Pivot 2: column 5 leaves basis and column 1 enters

┌──────────┬───┬─────┬─────┬─────────┬─────────┬──────────┬──────────┬─────────┐
│          │ z │ x_1 │ x_2 │     x_3 │     x_4 │      x_5 │      x_6 │     RHS │
│ Obj Func │ 1 │   0 │   0 │ -203/50 │ -403/50 │ -2514/25 │ -5029/50 │ -253/50 │
├──────────┼───┼─────┼─────┼─────────┼─────────┼──────────┼──────────┼─────────┤
│   Cons 1 │ 0 │   1 │   0 │  -21/50 │  -21/50 │     2/25 │    -3/50 │   29/50 │
│   Cons 2 │ 0 │   0 │   1 │  -11/25 │    3/50 │     3/50 │     2/25 │   14/25 │
└──────────┴───┴─────┴─────┴─────────┴─────────┴──────────┴──────────┴─────────┘

Optimality reached. Pivot count = 2
Minimal value = -253/50 = -5.06

Final tableau

┌──────────┬───┬─────┬─────┬─────────┬─────────┬─────────┐
│          │ z │ x_1 │ x_2 │     x_3 │     x_4 │     RHS │
│ Obj Func │ 1 │   0 │   0 │ -203/50 │ -403/50 │ -253/50 │
├──────────┼───┼─────┼─────┼─────────┼─────────┼─────────┤
│   Cons 1 │ 0 │   1 │   0 │  -21/50 │  -21/50 │   29/50 │
│   Cons 2 │ 0 │   0 │   1 │  -11/25 │    3/50 │   14/25 │
└──────────┴───┴─────┴─────┴─────────┴─────────┴─────────┘

Minimial value = -253//50 = -5.06
4-element Vector{Rational}:
 29//50
 14//25
   0
   0
```



## Numerical Solution

The function `lp_solve` uses a standard linear program solver to solve the tableau. 
We use the [HiGHS](https://ergo-code.github.io/HiGHS/stable/) solver.

```
julia> T
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ RHS │
│ Obj Func │ 1 │   1 │   8 │  -8 │  -8 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │  -8 │  -6 │   6 │   3 │  -8 │
│   Cons 2 │ 0 │   6 │  -8 │   1 │  -3 │  -1 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┘


julia> lp_solve(T)
Minimal objective value = -5.06

4-element Vector{Float64}:
 0.5800000000000001
 0.5599999999999999
 0.0
 0.0
```