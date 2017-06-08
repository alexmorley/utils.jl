# IMAGES
using Images
export nanfilt!, nanfilt, nanmaximum, nanminimum

function nanfilt!(v::Vector,σ)
    nans = .!(isnan.(v))
    v = view(v,  findfirst(nans):findlast(nans))
    imfilter!(v, v, KernelFactors.IIRGaussian([σ]))
end

function nanfilt(v::Vector,σ)
    t = copy(v)
    nanfilt!(t, σ)
    return t
end


# NaN MATH
using NaNMath; const nm = NaNMath
nanmaximum(x) = nm.maximum(x)
nanminimum(x) = nm.minimum(x)
