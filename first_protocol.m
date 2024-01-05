data = ALLEEG.data(1, :, :);
MI = [];
MI_out = [];

% MI_out is struct. For each trial, it has Amp_freqs x Phase_freqs x time points
% Amp_freqs  = Amp_min : Amp_step : Amp_max;
% Phase_freqs = Phase_min: Phase_step : Phase_max;
% time points are from the epoch. It seemed that epoch is from -10s to 30s

% MI = Amp_freqs x Phase_freqs x number of trials (for mouse1, 100 trials)

Phase_min=2;
Phase_max=8;
Phase_step=1;
Amp_min=20; 
Amp_max=100;
Amp_step=5;
m_sec=1;    %Amount of seconds computed per frame
dt=1;          %Seconds between frames
options={'filter','wavelet'};

fs=2000; % sampling rate = 2000 Hz. Temporal resolution is 0.5ms
Param=[Phase_min,Phase_max,Phase_step,Amp_min,Amp_max,Amp_step];
options{end+1}='param';
options{end+1}=Param;
options{end+1}='plotless';
options{end+1}='PAC3D';
options{end+1}=[m_sec,dt];


for i = 1:800 % 200 can chage by epoch number.
    x = data(1, :, i);
    [tmp_a, tmp_b] = PAC_par(x,[],fs,[],options{:});
    MI(:,:,i) = tmp_a;
    MI_out = [MI_out; tmp_b];
    % plot(M1_out.theta, M1_out.Amp,'rx');
    close all;
end

                                                                                                                                                                                                                                                                                                                                                                                                                                                          
save('TBUS_merge', 'MI', 'MI_out', '-v7.3'); 
%change the file name
%바로 저장을 하면 왼쪽에 열려있는 '현재폴더'에 저장됨.
%save('file name', 'information1:M1', 'infomation2:MI_out', 'version')
