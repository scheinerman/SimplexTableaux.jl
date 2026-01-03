# SimplexTableaux

### Breaking Change in Version 0.5 

> The default `Tableau(A, b, c)` creates a tableau for an LP in *standard* form. To create a tableau for a *canonical* LP, use `Tableau(A, b, c, true)`. 

The rationale for this change is that the Simplex Method operates on standard form LPs, so that should be the default. Hence, `Tableau(A, b, c)` is equivalent to `Tableau(A, b, c, false)`

## Overview

This module can be used to show how to solve linear programming problems using 
the Simplex Method by pivoting tableaux. 

This is an illustration project for solving optimization problems of the form 
of the form $\min c^T x$ subject to $Ax = b$ and $x \ge 0$ (standard form)
and $\min c^T x$ subject to $Ax ≥ b$ and $x \ge 0$ (canonical form).


See [the documentation](https://docs.juliahub.com/General/SimplexTableaux/stable/) for information on how to use this module. 

## Caveats

* This is a demonstration project and is not suitable for solving large linear programming (LP) problems. 

* This module is set up for minimization problems only. To solve a maximization problem, replace the objective function coefficients `c` with `-c`.

* All data is stored using arbitrary precision integers (that is, `Rational{BigInt}`) which gives exact results, but is much slower than floating point arithmetic. These issues are negligible for small problems. 
