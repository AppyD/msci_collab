function [startInd,endInd] = date_indices(startd,endd, abs_start, abs_end)
    
    startInd = months(abs_start,startd);
    
    % first check that proposed endd is before data ends
    if months(endd,abs_end) <= 0
        endd = abs_end;
        mytext = ['Your end date is on or after 01 Jan 2015. There is no ' ...
                  'data beyond this date.'];
        disp(mytext);
    end
    
    % then check if startd is before the data begins
    if  startInd <= 0
        startInd = 1;
        mytext = ['Your starting date is on or before 01 Jan 1870. There is no ' ...
                  'data before this date.'];
        disp(mytext);
    end
    
    % check that startd is before endd; if not, reverse them
    if months(startd,endd) < 0
        t = startd;
        startd = endd;
        endd = t;
    end
    
    endInd = startInd + months(startd,endd);
    
end