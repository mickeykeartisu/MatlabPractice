function [] = baion_rms_plot(shift_ms, rms_ii_baion, baion_max, sound_type, takasa_no, save_folder)


x = (0: length(rms_ii_baion{1})-1)*(shift_ms/1000);
count_i = 1;

figure
plot(x, rms_ii_baion{count_i});
hold on

legend_str  = cell(baion_max, 1);
legend_str{1} = '基音';

for i = (count_i)+1: baion_max
    plot(x, rms_ii_baion{i});
    legend_str{i} = [num2str(i) '倍音'];
end
title(['RMS-' sound_type '-' num2str(takasa_no) ]);
xlabel('Time [s]','FontSize',16);
ylabel('Log Magnitude [dB]','FontSize',16);
if (strcmp(sound_type, 'gestopft') == 1)
    xlim([0 2.5]);
    ylim([-80 10]);
elseif (strcmp(sound_type, 'straight') == 1)
    xlim([0 3.0]);
    ylim([-80 10]);
else
    xlim([0 3.5]);
    ylim([-90 0])
end
legend(legend_str,'FontSize', 14, 'Location', 'northeast');
set(gca,'FontSize',14);
saveas(gcf,[save_folder '1-6-baion-RMS' sound_type '-' num2str(takasa_no) '.jpg']);

end