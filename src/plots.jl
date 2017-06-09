export sslice
using PyCall
"""
	function sslice(a,b)
Usefull in Gridspec calls
"""
function sslice(a,b)
    pycall(pybuiltin("slice"), PyObject, a,b+1)
end
