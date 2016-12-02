% Matrix cropping : [CM,minInd,maxInd] = cropped(M,startValue, endValue)
%------------------------------------
% Imagined use: cropping large vector of data points based on
% longitude/latitude range
%
% M is a 1D matrix (vector)
% startValue and endValues are numbers (not restricted to integer) to be 
% found in the matrix    N.B.(NOT an index!)
% CM - cropped matrix

function [CM,minInd,maxInd] = cropped(M, startValue, endValue)
    
    [~,minInd] = ismember(startValue, M);
    [~,maxInd] = ismember(endValue, M);
    
    if maxInd < minInd
        t = maxInd;
        maxInd = minInd;
        minInd = t;
    end
    
    try
        CM = M(minInd:maxInd);
        
    catch
        msgID = 'cropped:BadIndex';
        msg = 'Invalid index';
        baseException = MException(msgID,msg);

        try
            assert(isnan(maxInd), 'cropped:BadType',...
                'Index value is a NaN');
        catch causeException
            baseException = addCause(baseException,causeException);
        end

        if minInd == 0 || maxInd == 0
            msgID = 'cropped:BadInput';
            msg = 'Value not in matrix.';
            causeException2 = MException(msgID,msg);
            baseException = addCause(baseException,causeException2);
        end

        throw(baseException);
    end
end