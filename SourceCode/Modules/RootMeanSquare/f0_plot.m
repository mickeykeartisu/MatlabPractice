
foldername = 'C:/work/matlab/prog_tsukuda/ana_baion/';

A = readmatrix([num2str(foldername) 'f0.txt']);
B = (round(A, 1))';
x = [1 2 3 4];
figure
b = bar(x, B);
hold on
title('Fundamental Frequency', 'FontSize', 16);
xticks([1 2 3 4]);
xticklabels({'B♭2', 'F3', 'B♭3', 'F4'});
xlabel('Pitch', 'FontSize', 16);
ylabel('Frequency [Hz]','FontSize',16);
set(gca,'FontSize',14);
for k = 1: 3
    xtips = b(k).XEndPoints;
    ytips = b(k).YEndPoints;
    labels = string(b(k).YData);
    text(xtips, ytips, labels, 'HorizontalAlignment','center','VerticalAlignment','bottom');
end
ylim([0 500]);
legend({'normal', 'straight', 'gestopft'},'FontSize', 12, 'Location', 'northeast');
hold off
