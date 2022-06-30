function [data_xday] = AverXday(data, daynum)
% calculate the X-day (accumulated) time series
% daynum = 5;

data = reshape(data, length(data),1);
for i = 1:fix(daynum/2)
    data_temp(:,i) = [zeros(i,1);data(1:end-i)];
end

for i = 1:fix(daynum/2)+1
    data_temp(:,i+fix(daynum/2)) = [data(i:end);zeros(i-1,1)];
end

data_xday = mean(data_temp,2);



