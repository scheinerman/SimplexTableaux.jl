
> **Note**: This is early days for this module. Anything before 0.1.0 is subject to massive changes. 

# SimplexTableaux

This module can be used to show how to solve linear programming problems using 
the simplex method by pivoting tableaux. 

This is an illusration project for solving feasible optimization problems of the form 
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

