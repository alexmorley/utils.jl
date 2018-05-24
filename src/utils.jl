module utils
    include("base.jl")
    export slicedimview, nextpow2, allequal, offdiagind, offdiag
    export findnmax, findnmin
    export rotatexy

    include("old.jl")
    
    include("misc.jl")
    export nanmaximum, nanminimum, nan2zero!
    export twodresample
    export mmtoin, intomm
    export wavedec2d

    include("plots.jl")
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
