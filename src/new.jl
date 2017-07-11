export nanfilt!, nanfilt, nanmaximum, nanminimum, nan2zero!
export twodresample

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

# DSP
using DSP

function twodresample(mat, rate, fs=1250)
    out = zeros(floor(Int, size(mat,1)*rate), size(mat,2))
    for i in 1:size(mat,2)
        out[:,i] = resample(mat[:,i],rate)
    end
    floor(Int, fs*rate), out
end

# Wavelets
using Wavelets
function wavedec2d{T<:AbstractFloat}(clips::Array{T,2},
                   wavtype = WT.haar)
    # level of wavelet transform
    wt = wavelet(wavtype)
    N = floor(Int,log2(size(clips,2)))
    # intialise array
    components_all = zeros(clips)
    for i in 1:size(components_all,1)
        components_all[i,:] = dwt(clips[i,:], wt, N)
    end
    return components_all::Array{T,2}
end


# NaN MATH
using NaNMath; const nm = NaNMath
nanmaximum(x) = nm.maximum(x)
nanminimum(x) = nm.minimum(x)

nan2zero!(arr) = arr[isnan.(arr)] .= zero(eltype(arr))
