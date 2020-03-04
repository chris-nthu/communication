clc; clear;

time = 0.6;
while 1
    timer = tic;
    time = time-toc(timer);
    if(time<0)
        break;
    end
end