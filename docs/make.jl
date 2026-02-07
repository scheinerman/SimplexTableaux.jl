# execute this file in the docs directory with this
# julia --color=yes --project make.jl

using Documenter, SimplexTableaux
makedocs(;
    pages=[
        "Overview" => "index.md",
        "Tutorial" => "tutorial.md",
        "Duality" => "dual.md",
        "Other Functions" => "other.md",
        "API" => "api.md",
    ],
    sitename="SimplexTableaux",
)
