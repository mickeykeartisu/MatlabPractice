clear all

T = 16;
setGain = 6;
maxfreq = 0;

s_num = 1;
e_num = 1;

Weighting_factor = zeros(1,T);
gainS_max = zeros(1,T);
gainS_ave = zeros(1,T);
gainS_t = cell(1,T);
for n = s_num:1:e_num,
    inputName = ['AN' num2str(n, '%02d')];
    load(['../mat_data/gainS/gainS_' inputName '_' num2str(T) 'Band_' num2str(setGain) 'dB_hanning_' num2str(maxfreq) 'Hz'])
    
%     figure
%     plot(gainS{1});
%     figure
%     plot(gainS{16});
%     
%     
%     
%     for t = 1:T,
%         gainS_max(t) = max(gainS{t});
%         gainS_ave(t) = mean(gainS{t});
%     end
%     for t = 1:T,
%         Weighting_factor(t) = min(gainS_max)/gainS_max(t);
%         for ii = 1:length(gainS{t})
%             if gainS{t}(ii) >  min(gainS_max),
%                 gainS_t{t}(ii) = gainS{t}(ii) *  Weighting_factor(t);
%             else
%                 gainS_t{t}(ii) = gainS{t}(ii);
%             end
%         end
%     end
%     
%     
%     
%     figure
%     plot(Weighting_factor);
%     
%     figure
%     plot(gainS_t{1});
%     figure
%     plot(gainS_t{8});
    
    
    %dBで計算
%     for t = 1:T,
%         gainS_max(t) = max(gainS{t});
%         gainS_ave(t) = mean(gainS{t});
%     end
%     for t = 1:T,
%         Weighting_factor(t) = min(gainS_max)/gainS_max(t);
%         for ii = 1:length(gainS{t})
% %             if gainS{t}(ii) >  min(gainS_max),
%                 gainS_t{t}(ii) = gainS{t}(ii) *  Weighting_factor(t);
% %             else
% %                 gainS_t{t}(ii) = gainS{t}(ii);
% %             end
%         end
%         gainS_t{t} = exp(gainS_t{t}/log(10));
%     end
%     
%     
%     
%     figure
%     plot(Weighting_factor);
%     
%     figure
%     plot(gainS_t{1});
%     figure
%     plot(gainS_t{8});
    
    for t = 1:T,
%         gainS{t} = mean(gainS{t});
        gainS{t} = 20*log10(gainS{t});
    end
    figure
    plot(gainS{1});
%     figure
%     plot(gainS{8});
    %目標のdB値でハードクリッピング
    for t = 1:T,
        for ii = 1:length(gainS{t}),
            if gainS{t}(ii) > setGain,
                gainS_t{t}(ii) = setGain;
            elseif  gainS{t}(ii) < -1 * setGain,
                gainS_t{t}(ii) = -1 * setGain;
            else
                gainS_t{t}(ii) =  gainS{t}(ii);
            end
        end
        gainS_t{t} = exp(gainS_t{t}/20*log(10));
    end
    
    for t = 1:T,
        for ii = 1:length(gainS{t}),
            if gainS{t}(ii) == setGain,
                mm = 1;
                for m = ii:(gainS{t}),
                    mm = mm+1;
                    if gainS{t}(m) ~= setGain;
                        break
                    end
                end
            end
            if gainS{t}(ii) == -setGain,
                mm = 1;
                for m = ii:(gainS{t}),
                    mm = mm+1;
                    if gainS{t}(m) ~= setGain;
                        break
                    end
                end
            end
            
            
        end
        gainS_t{t} = exp(gainS_t{t}/20*log(10));
    end
    
    
    
%     for t = 1:T,
%         for ii = 1:length(gainS{t}),
%             if gainS{t}(ii) > setGain,
%                 weight = setGain/gainS{t}(ii);
%             elseif  gainS{t}(ii) < -1 * setGain,
%                 gainS_t{t}(ii) = -1 * setGain;
%             else
%                 gainS_t{t}(ii) =  gainS{t}(ii);
%             end
%         end
%         gainS_t{t} = exp(gainS_t{t}/20*log(10));
%     end
%     
    
    figure
    plot(20*log10(gainS_t{t}));    
%     figure
%     plot(gainS_t{1});
%     figure
%     plot(gainS_t{8});
    
    
    
end