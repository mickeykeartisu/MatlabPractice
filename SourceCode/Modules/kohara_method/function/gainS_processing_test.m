function [ gainS_t,Weighting_factor,gainS_max,gainS_ave] = gainS_processing_test( gainS ,T,setGain)
%GAINS_PROCESSING_TEST ‚±‚ÌŠÖ”‚ÌŠT—v‚ð‚±‚±‚É‹Lq


gainS_t = cell(1,T);

if nargin == 3,
    for t = 1:T,
        gainS{t} = 20*log10(gainS{t});
%         figure
%         plot(gainS{t});
        for ii = 1:length(gainS{t}),
            if gainS{t}(ii) > setGain,
                gainS_t{t}(ii) = setGain;
            elseif  gainS{t}(ii) < -1 * setGain,
                gainS_t{t}(ii) = -1 * setGain;
            else
                gainS_t{t}(ii) =  gainS{t}(ii);
            end
        end
%         figure
%         plot(gainS_t{t});
        gainS_t{t} = exp(gainS_t{t}/20*log(10));

    end
    
    Weighting_factor=0;
else

    Weighting_factor = zeros(1,T);
    gainS_max = zeros(1,T);
    gainS_ave = zeros(1,T);


    for t = 1:T,
        gainS{t} = 20*log10(gainS{t});
        gainS_max(t) = max(gainS{t});
        gainS_ave(t) = mean(gainS{t});
    end
    for t = 1:T,
        Weighting_factor(t) = min(gainS_max)/gainS_max(t);
        for ii = 1:length(gainS{t})
            if gainS{t}(ii) >  min(gainS_max),
                gainS_t{t}(ii) = gainS{t}(ii) *  Weighting_factor(t);
            else
                gainS_t{t}(ii) = gainS{t}(ii);
            end
        end
    %     gainS_t{t} = gainS_t{t} / 2;
    end

    for t = 1:T,
        Weighting_factor(t) = min(gainS_max)/gainS_max(t);
        for ii = 1:length(gainS{t}),
            gainS_t{t}(ii) = gainS{t}(ii) *  Weighting_factor(t);
        end
        gainS_t{t} = exp(gainS_t{t}/20*log(10));
    end
end




end

