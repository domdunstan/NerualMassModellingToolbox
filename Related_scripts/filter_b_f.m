function[output]=filter_b_f(EEG, cutoff, sample_rate,high_or_low,order )

% apply filter
ny=sample_rate/2;
cutoff=cutoff/ny;


[b,a] = butter(order, cutoff, high_or_low);


EEG_f = filtfilt(b,a,EEG);

 output = EEG_f;

end
