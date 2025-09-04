# Duality

## The dual function

If a tableau `T` is created from a canonical minimization problem, then `dual(T)` 
returns a new tableau corresponding to dual linear program. However, `dual(T)` is 
also a minimization problem. The minimum value of `dual(T)` is negative that of `T`. 

That is, if `T` represents the LP $\min c^T x$ s.t. $Ax \ge b$, $x\ge0$, then
`dual(T)` respresents the LP $\min b^T y$ s.t. $-A^T y \le -c$, $y\ge0$. 

## Example

```
julia> A = [11 2 11; 8 6 9; 8 8 5; 6 5 8; 4 1 2; 2 -1 4];

julia> b = [0, 1, 10, 3, 2, 5];

julia> c = [3, 4, 7];

julia> T = Tableau(A,b,c):

┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ x_7 │ x_8 │ x_9 │ RHS │
│ Obj Func │ 1 │  -3 │  -4 │  -7 │   0 │   0 │   0 │   0 │   0 │   0 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │  11 │   2 │  11 │  -1 │   0 │   0 │   0 │   0 │   0 │   0 │
│   Cons 2 │ 0 │   8 │   6 │   9 │   0 │  -1 │   0 │   0 │   0 │   0 │   1 │
│   Cons 3 │ 0 │   8 │   8 │   5 │   0 │   0 │  -1 │   0 │   0 │   0 │  10 │
│   Cons 4 │ 0 │   6 │   5 │   8 │   0 │   0 │   0 │  -1 │   0 │   0 │   3 │
│   Cons 5 │ 0 │   4 │   1 │   2 │   0 │   0 │   0 │   0 │  -1 │   0 │   2 │
│   Cons 6 │ 0 │   2 │  -1 │   4 │   0 │   0 │   0 │   0 │   0 │  -1 │   5 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
```
The result of `simplex_solve!` on this tableau is $15/2$. 

The tableau for the dual problem is:
```
julia> dT = dual(T)
┌──────────┬───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│          │ z │ x_1 │ x_2 │ x_3 │ x_4 │ x_5 │ x_6 │ x_7 │ x_8 │ x_9 │ RHS │
│ Obj Func │ 1 │   0 │   1 │  10 │   3 │   2 │   5 │   0 │   0 │   0 │   0 │
├──────────┼───┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│   Cons 1 │ 0 │ -11 │  -8 │  -8 │  -6 │  -4 │  -2 │  -1 │   0 │   0 │  -3 │
│   Cons 2 │ 0 │  -2 │  -6 │  -8 │  -5 │  -1 │   1 │   0 │  -1 │   0 │  -4 │
│   Cons 3 │ 0 │ -11 │  -9 │  -5 │  -8 │  -2 │  -4 │   0 │   0 │  -1 │  -7 │
└──────────┴───┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
```
The result of `simplex_solve!(dT)` is $-15/2$. 

