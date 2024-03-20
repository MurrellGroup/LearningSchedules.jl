using LearningSchedules
using Documenter

DocMeta.setdocmeta!(LearningSchedules, :DocTestSetup, :(using LearningSchedules); recursive=true)

makedocs(;
    modules=[LearningSchedules],
    authors="murrellb <murrellb@gmail.com> and contributors",
    sitename="LearningSchedules.jl",
    format=Documenter.HTML(;
        canonical="https://MurrellGroup.github.io/LearningSchedules.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/MurrellGroup/LearningSchedules.jl",
    devbranch="main",
)
