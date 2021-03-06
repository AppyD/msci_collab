classdef Cluster
    properties
        X_init
        Y_init
        Data
        
        Data_List
        pointsChecked
        identificationList
        
        FoundCluster
        a
        b
    end
    
    methods
        function obj = Cluster(Data)
            % Data has either a 1 or 0.
            obj.Data = Data;
            obj.Data_List = reshape(Data, [size(Data,1)*size(Data,2), 1]);
            
            obj.pointsChecked = zeros(length(obj.Data_List), 1);
            obj.identificationList = zeros(length(obj.Data_List), 1);
        end
        
        function obj = IsolateCluster(obj, StartCoordinates)
            obj.X_init = StartCoordinates(1);
            obj.Y_init = StartCoordinates(2);
            
            obj.pointsChecked = zeros(length(obj.Data_List), 1);
            obj.identificationList = zeros(length(obj.Data_List), 1);
        
            
            obj.FoundCluster = zeros(size(obj.Data));
            
            [obj.a,obj.b] = size(obj.Data);
            
            obj = obj.search(StartCoordinates);
        end
        
        function obj = search(obj, coordinates)
            x = coordinates(1);
            y = coordinates(2);
            
            if ( (1<=x) && (obj.a>=x) && (1<=y) && (obj.b>=y))
                nocols= size(obj.Data, 2);
                norows = size(obj.Data,1);
                positionInData = norows*(y-1)   +   x;


                if obj.pointsChecked(positionInData, 1) == 0
                    obj.pointsChecked(positionInData, 1) = 1;
                    if obj.Data_List(positionInData) == 1
                        %disp('true');

                        theRowInFoundCluster = x;
                        theColInFoundCluster = y;

                        obj.FoundCluster(theRowInFoundCluster, theColInFoundCluster) = 1;

                        % Add to identification list
                        if obj.identificationList(positionInData)==0
                            obj.identificationList(positionInData) = 1;
                            % CHECK OTHER AVENUES
                            obj=obj.search([x,y+1]);
                            obj=obj.search([x+1,y+1]);
                            obj=obj.search([x+1,y]);

                            obj=obj.search([x+1,y-1]);
                            obj=obj.search([x,y-1]);
                            obj=obj.search([x-1,y-1]);

                            obj=obj.search([x-1,y]);
                            obj=obj.search([x-1,y+1]);
                        end
                    end
                end
            end
        end
    end
end
            