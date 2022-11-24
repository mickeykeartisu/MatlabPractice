function label = spoffsetlabel(label, offset)
% SPOFFSETLABEL  Shift times in spwave label structure
%
%	SPOFFSETLABEL(LABEL, OFFSET);
%	LABEL: Label structure for spwave.
%	OFFSET: Offset time in second.

for k = 1:length(label),
    label(k).time = label(k).time + offset;
end
