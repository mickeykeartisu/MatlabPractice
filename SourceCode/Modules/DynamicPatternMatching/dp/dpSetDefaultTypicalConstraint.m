function type = dpSetDefaultTypicalConstraint(type)

if isempty(strmatch('DP_DEFAULT_TYPICAL_CONSTRAINT', who('global'))),
  global DP_DEFAULT_TYPICAL_CONSTRAINT;
  DP_DEFAULT_TYPICAL_CONSTRAINT = 1;
else
  global DP_DEFAULT_TYPICAL_CONSTRAINT;
end

DP_DEFAULT_TYPICAL_CONSTRAINT = type;
