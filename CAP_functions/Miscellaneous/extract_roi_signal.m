function roi_signal = extract_roi_signal(data,roi)

roi_num = length(unique(roi))-1;
sz = size(data);

if length(sz) < 4
    sz(4) = 1;
end

nan_mask = ~isnan(mean(data,4));
roi = roi .* nan_mask;

data = reshape(data,[sz(1)*sz(2)*sz(3),sz(4)]);

roi_signal = zeros(sz(4),roi_num);

for i = 1:roi_num
   roi_index = find(roi == i);
   data_i =  data(roi_index,:);
   roi_signal(:,i) = mean(data_i);
end

% roi_signal = zscore(roi_signal);