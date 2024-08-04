require 'has_target'

HasRange = HasTarget:new()

function HasRange:new(range)
  local new = setmetatable({}, {__index = self})
  return new
end
