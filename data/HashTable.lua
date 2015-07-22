-----------------------------------------------------------------------------------------
--
-- HashTable.lua
--
-----------------------------------------------------------------------------------------
print( "Loading HashTable script ..... " )
HashTable = {}
HashTable.__index = HashTable

-- Constructs an empty HashTable
-- Useage:
-- 		import( "HashTable" ) 
-- 		local table = HashTapble.new()
function HashTable.new(o)
    o = o or {}
    setmetatable( o, HashTable )

    o.data = {}
    o._size = 0

    return o
end

-- Returns the number of key-value mappings in this HashTable.
-- @return 	the number of key-value mappings in this HashTable
function HashTable:size( )
	return self._size
end

-- Returns true if this HashTable contains no key-value mappings.
-- @return 	true if this HashTable contains no key-value mappings
function HashTable:isEmpty( )
	return self._size == 0
end

-- Removes all of the mappings from this HashTable.
function HashTable:clear( )
	self.data = {}
	self._size = 0
end

-- Returns true if this HashTable contains a mapping for the specified key.
-- @param 	key 	The key whose presence in this HashTable is to be tested
-- @return 			true if this HashTable contains a mapping for the specified key.
function HashTable:containsKey( key )
	return self.data[tostring(key)] ~= nil
end

-- Returns true if this HashTable maps one or more keys to the specified value.
-- @param 	value 	value whose presence in this HashTable is to be tested
-- @return 			true if this HashTable maps one or more keys to the specified value
function HashTable:containsValue( value )
	for k,v in pairs(self.data) do
		return v == value
	end
	return false
end

-- Associates the specified value with the specified key in this HashTable.
-- @param 		keyOrValue		key with which the specified value is to be associated
-- @param 		value 			value to be associated with the specified key
-- @return 						the previous value associated with key, or null if there was no mapping for key.
-- Param value is optional. The keyOrValue will be stringified. foo:put(bar) is equals to foo:put(bar, bar)
function HashTable:put( keyOrValue, value )
	if not value then
		value = keyOrValue
	end

	local ret = nil
	if self:containsKey(keyOrValue) then
		ret = self:get(keyOrValue)
	else
		self._size = self._size+1
	end
	self.data[tostring(keyOrValue)] = value
	return ret
end

-- Returns the value to which the specified key is mapped, or nil if this HashTable contains no mapping for the key.
-- @param	key 	the key whose associated value is to be returned
-- @retgurn 		the value to which the specified key is mapped, or null if this HashTable contains no mapping for the key
function HashTable:get( key )
	return self.data[tostring(key)]
end

-- Removes the mapping for the specified key from this HashTable if present.
-- @param key 	key whose mapping is to be removed from the HashTable
-- @return 		the previous value associated with key, or nil if there was no mapping for key.
function HashTable:remove( key )
	local value = self.data[tostring(key)]
	if (value) then 
		self.data[tostring(key)] = nil
		self._size = self._size-1
	end
	return value
end

-- Returns an array of the values contained in this HashTable.
-- @return 		an array of the values contained in this HashTable
function HashTable:values( )
	local values = {}
	for k,v in pairs(self.data) do
		table.insert(values, v)
	end
	return values
end

-- Returns an array of the keys contained in this HashTable.
-- @return 		a n array of the keys contained in this HashTable
function HashTable:keySet( )
	local keys = {}
	for k,v in pairs(self.data) do
		table.insert(keys, k)
	end
	return keys
end	

-- Copies all of the values from the specified keySet and valueSet to this HashTable.
-- @param keySet 	key names as array
-- @param valueSet	values as array
function HashTable:putAll( keySet, valueSet )
	for i=1,#keySet do
		self:put(keySet[i], valueSet[i])
	end
end

-- Returns a shallow copy of this HashTable instance: the values themselves are not cloned.
-- @return 		a shallow copy of this HashTable
function HashTable:clone( )
	local clone = HashTable.new()
	for k,v in pairs(self.data) do
	 	clone:put(k, v)
	end
	return clone
end

-- Copies all of the mappings from the specified HashTable to this HashTable.
-- @param ht 		a HashTable to copy 
function HashTable:putHashTable(ht)
	local function wrapper( k, v )
		self:put(k, v)
	end

	ht:foreach(wrapper)
end

-- Performs the specified action on each element of this HashTable.
-- @param f 	the action as function
-- Example:
-- 			local function bar(k, v) print(k.."="..v) end
-- 			foo:foreach(bar) 
function HashTable:foreach( f )
	for k,v in pairs(self.data) do
	 	f(k,v)
	end
end

-- HashTable to string (its not the __tostring()). 
-- @return 		HashTable as string
-- use foo:tostring(), tostring(foo) is not the same.
function HashTable:tostring()
	local str = "HashTable[\n"
	for k,v in pairs(self.data) do
		str = str.."\t".. k .." = ".. tostring(v) .."\n"	
	end
	str = str.."\n]"
	return str
end