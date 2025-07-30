
> **Note**: This is early days for this module. Anything before 0.1.0 is subject to massive changes. 

# SimplexTableaux

This module can be used to show how to solve linear programming problems using 
the simplex method by pivoting tableaux. 

This is an illusration project for solving  feasible optimization problems of the form 
$\min c^T x$ subject to $Ax ≥ b$ and $x \ge 0$ (canonical form)
and of the form $\min c^T x$ subject to $Ax = b$ and $x \ge 0$ (standard form).


See [the documentation](https://docs.juliahub.com/General/SimplexTableaux/stable/) for information on how to use this module. 

## Caveats

As a demonstration project, this is not suitable for solving actual linear programming (LP) problems. 

At present the user needs to specify a starting basis; see the documentation. 

This module is set up for minimization problems only. 

This module solves LPs using the simplex algorithm which is not the most performant method. 
Further, all data is stored using arbitrary precision integers (that is, `Rational{BigInt}`) which gives 
exact results, but is much slower than floating point arithmetic. These issues are negligible for small problems. 
