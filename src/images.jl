# IMAGES
using Images
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

function imfilter_gaussian(img, sigma; kwargs...)
    imfilter(img,
        KernelFactors.IIRGaussian(sigma; kwargs...))
end

