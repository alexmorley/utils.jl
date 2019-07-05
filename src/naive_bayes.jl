using Random
using StatsBase
using Distributions

struct NaiveBayes
    μ::Array{Float64,2}
    σ::Array{Float64,2}
    priors::Array{Float64,1}
    classes::Array{Int64,1}
end

function fit_params(X, y)
    n_f, n_obs = size(X)
    classes = unique(y)
    nclasses = length(classes)
    μ = zeros(Float64, n_f, nclasses)
    σ = zeros(Float64, n_f, nclasses)
    obs_per_class = (y .== cl for cl in classes)
    priors = mean.(obs_per_class) #i = [0.5,0.5] #
    for (i,o) in enumerate(obs_per_class)
        μ[:, i:i] .= mean(X[:,o],dims=2)
        σ[:, i:i] .= std(X[:,o],dims=2)
    end
    return μ, σ, priors, classes
end

import StatsBase.predict

function predict(d::NaiveBayes, X::Matrix)
    nclasses = length(d.priors)
    n_f, n_obs = size(X)
    predicted_class = zeros(Int, n_obs)
    ll = zeros(Float64, nclasses)
    for obs in 1:n_obs
        for cl in 1:nclasses
            ll[cl] = log(d.priors[cl])
            ll[cl] += sum(logpdf.(Normal.(d.μ[:,cl], d.σ[:,cl]), X[:, obs].+1e-8))
        end
        predicted_class[obs] = d.classes[findmax(ll)[2]]
    end
    return predicted_class
end

import StatsBase.fit
function fit(model::Type{NaiveBayes}, X::Array{Float64,2}, y::Array{Int64,1})
    μ, σ, priors,classes = fit_params(X, y)
    NaiveBayes(μ, σ, priors, classes)
end

function test()
	Random.seed!(0)
	X = rand(5, 100) #features, observatins
	y = ones(Int, 100)
	y[1:50] .= 2
	X[:, 1:50] .*= 2
	X[:, 51:end] ./= 2

	model = fit(NaiveBayes, X,y)
	prediction = predict(model, X)
	@assert prediction == y
end
