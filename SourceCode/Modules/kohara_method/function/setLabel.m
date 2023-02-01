function setLabel(xlab, ylab, titlab, fontsize)
% setLabel(xlab, ylab, titlab, fsize)
% xlab:   xlabel()
% ylab:   ylabel()
% titlab: title()
% fontsize: Font size. Default: 9.
% éQçl ÅF xlabel, ylabel, title.

% if nargin < 4,
%     fontsize = 9;
% end

switch nargin,
    case 2
        xlabel(xlab)
        ylabel(ylab)
    case 3
        xlabel(xlab)
        ylabel(ylab)
        title(titlab)
    case 4
        xlabel(xlab,'FontSize',fontsize)
        ylabel(ylab,'FontSize',fontsize)
        if ~isempty(titlab),
            title(titlab,'FontSize',fontsize)
        end
end