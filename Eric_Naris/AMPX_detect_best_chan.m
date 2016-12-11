function [keep_chan] = AMPX_detect_best_chan(cfg_in, data, ExpKeys_remap)

if ~isfield(data,'labels_remap')
    warning('data  should have been remapped')
end
cfg_def.gamma_freq = [40 55];
cfg_def.ch = 1:64;
cfg_def.plot = 1;
[~, ~, cfg_def.ch] = Naris_BestChan_remap(ExpKeys_remap, 'location', 'vl');
cfg = ProcessConfig(cfg_def, cfg_in);

if isfield(cfg, 'all_chan')
    cfg.ch = 1:64;
end
%% get some psds for the pole of interest
Remove_ft()

Hs = spectrum.welch('Hann',4096,50); % for 4x decimated data
%Hs = spectrum.welch('Hann',16384,50); % for undecimated data
for iCh =cfg.ch
    
    fprintf('psd %d\n',iCh);
    data.psd{iCh} = psd(Hs,data.channels{iCh},'Fs',data.hdr.Fs);
    
end

%% housekeeping
% find gamma freq idxs
 for iCh =cfg.ch
     if ~isempty(data.psd{iCh})
         f_idx = find(data.psd{iCh}.Frequencies > cfg.gamma_freq(1) & data.psd{iCh}.Frequencies <= cfg.gamma_freq(2));
     else
continue
     end
 end
%% plot PSDs & collect gamma power
if cfg.plot
    figure;
end
out.gamma_power = zeros(length(cfg.ch),1);
for iCh = cfg.ch
    psd_norm = 10*log10(data.psd{iCh}.Data);
    %     psd_norm = psd_norm./nanmean(psd_norm);
    if cfg.plot
        subtightplot(8,8,iCh);
        plot(data.psd{iCh}.Frequencies,psd_norm,'b','LineWidth',2);
        set(gca,'XLim',[0 100],'XTick',0:10:100,'YTick',[]); grid on;
    end
    out.gamma_power(iCh) = nanmean(psd_norm(f_idx));
    
end

%% find best channels
[~,sort_idx] = sort(out.gamma_power,'descend');
keep_idx = sort_idx(1);
keep_chan = find([1:64]==keep_idx);

fprintf('\nSelected channels: '); fprintf('%d ',keep_chan); fprintf('\n');
    if cfg.plot

        ax = subtightplot(8,8,keep_chan);
        hold on
        plot(75, 30,'*r', 'markersize', 20)
        saveas(gcf, 'Chan_detect_PSDs.png')
    end

% data.channels = data.channels(keep_chan); % should be a channel select function