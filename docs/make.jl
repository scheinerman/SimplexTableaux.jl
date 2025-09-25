# execute this file in the docs directory with this
# julia --color=yes --project make.jl

using Documenter, SimplexTableaux
makedocs(;
    pages=[
        "Overview" => "index.md",
        "Tutorial" => "tutorial.md",
        # "Creating Tableaux" => "create.md",
        # "Bases" => "bases.md",
        # "Pivoting Tableaux" => "pivot.md",
        # "Solving LPs" => "solve.md",
        # "Dual LP" => "dual.md",
        "Other Functions" => "other.md",
        "API" => "api.md"
    ],
    sitename="SimplexTableaux",
)
