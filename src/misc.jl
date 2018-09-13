# Conversions
mmtoin(x::Real) = x/25.399986284
intomm(x::Real) = x*25.399986284

# Rounding
roundup(x,n)   = round(x,n) >= x ? round(x,n) : round(x+1/(10^n),n)
rounddown(x,n) = round(x,n) <= x ? round(x,n) : round(x+1/(10^n),n)

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

nans(x) = (z = similar(x); fill!(z,NaN))
