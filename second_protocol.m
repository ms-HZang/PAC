%%%%% ---- PART 1:  Avg of Whole data ---- %%%%%
MI_avg = mean(MI, 3); 

%%%%% ---- PART 2: Avg of Time resoluved data ---- %%%%%
%%% ---- Step 1: Initialize the result matrix ---- %%%
MI_time = MI_out.MI3;

%%% ---- Step 3: Process to sum n=600 data ---- %%%
for i = 1:38 %i=time, 1 1~2sec block to 39~40sec block
   for j = 1:800 %PAC_avg에서 맞춘 i값과 동일하게. %j = epoch
       tmp = MI_time(:, :, i) + MI_out(j).MI3(:,:,i);
       MI_time(:, :, i) = tmp;
   end
end

%%% ---- Step 5: Show the sample plot of result matrix
x = 2:1:8
y = 20:5:100

%pre -3 to -1
subplot(1,4,1);
surf(x,y,squeeze(mean(MI_time(:,:,8:10),3)));
shading interp 
view(2);
colorbar;
title('Pre (-3 to -1)s');
axis square

% induction
subplot(1,4,2);
surf(x,y,squeeze(mean(MI_time(:,:,11:12),3)));
shading interp 
view(2);
colorbar;
title('During (0 to 2)s');
axis square

%Post
subplot(1,4,3);
surf(x,y,squeeze(mean(MI_time(:,:,13:15),3)));
shading interp 
view(2);
colorbar;
title('Post (3 to 5)s');
axis square


%%% ---- Step 6: Save the result matrix to 'PAC_avg.mat' file ---- %%%
save('TBUS_125678_merge', 'MI_avg', 'MI_time', '-v7.3');