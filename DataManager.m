classdef DataManager
    %DataManager Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static)
        function assignStatus(DF)
            if length(DF.Data) > 1
                DF.LoadMsg = 'Loaded';
            else
                DF.LoadMsg = 'No data';
            end
        end
        
        function lh = addData(DF)
             lh = addlistener(DF, 'DataLoaded', ...
                @(src, ~)DataManager.assignStatus(src));
        end
    end
end