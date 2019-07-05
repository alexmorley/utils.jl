module utils
if VERSION >= v"0.7.0"
    using Statistics
else
    nothing
end


include("base.jl")
export flatten, unzip
export slicedimview, nextpow2, allequal, offdiagind, offdiag
export findnmax, findnmin
export rotatexy

include("old.jl")

include("misc.jl")
export from_choose
export nanmaximum, nanminimum, nan2zero!, nanmap, nanmapslices
export twodresample
export mmtoin, intomm
export wavedec2d

include("plots.jl")
export significance
export sslice

include("rsync.jl")

include("statsbase.jl")
export zscore_base, zscore_base!
export _bootstrap, bootstrap_confint

include("sorting.jl")
export bubble_sort!, bubble_sort_perm 

include("images.jl")
export nanfilt, nanfilt!, imfilter_gaussian
end
