export sslice
using PyCall
"""
	function sslice(a,b)
Usefull in Gridspec calls
"""
function sslice(a,b)
    pycall(pybuiltin("slice"), PyObject, a,b+1)
end

function significance(pval)
	if pval > 0.1
        sigsymbol = "ns"
        elseif pval > 0.05
        sigsymbol = "#"
        elseif pval > 0.01
        sigsymbol = "*"
        elseif pval > 0.001
        sigsymbol = "**"
        elseif pval < 0.001
        sigsymbol = "***"
    else
        sigsymbol = "sig unavailable"
    end
end
