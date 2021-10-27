function mat2roi(data,roi,roi_header,fname)

data_roi = roi;
roi_header.fname = fname;
roi_header.dt = [16 0];

roi_num = length(unique(roi))-1;

for roi_i = 1:roi_num
    idx = find(roi == roi_i);
    data_roi(idx) = data(roi_i);        
end

spm_write_vol(roi_header,data_roi);