classdef ExperimentData < handle

   properties (SetAccess = private)
      Path
      Label
      NumChannels
      TimePoint
      
      WellPosn
      PenetrationDepth
      MeanIntensity
      Data
   end
   
   properties (Transient)
      LoadListener
   end
   
   properties (Access = ?DataManager)
        WellData = ''
        PenData = ''
        LoadMsg = 'No Data'
   end
   
   events
      DataLoaded
   end
   
   methods
      function DF = ExperimentData(df_path,label, channel, time)
         DF.Path = df_path;
         DF.Label= label;
         DF.NumChannels= channel;
         DF.TimePoint= time;
         DF.LoadListener =  DataManager.addData(DF);
      end
      
      function loadData(DF)
         if (strcmp(DF.LoadMsg,'loaded'))
            disp(['Experiment',num2str(DF.Label),' has already been loaded.'])
            return
         end
         data = imread(DF.Path);
         DF.Data = data;
         if length(data) > 1
            notify(DF,'DataLoaded')
         end
      end
      
      function deleteData(DF)
         if (strcmp(DF.LoadMsg,'No Data'))
            disp('No data to delete.')
            return
         end
         DF.Data = [];
         DF.LoadMsg = 'No Data';
      end
      
      function setWellPosn(DF,wp)
         DF.WellPosn= wp;
         if DF.WellPosn == 0
            DF.WellData = 'No well in experiment';
         end
      end
            
      function setMeanIntensity(DF,mi)
         DF.MeanIntensity= mi;
         %TODO: add error catcher here
      end
      
      function printInfo(DF)
         disp('-------------------------')
         disp(['Path: ',num2str(DF.Path)])
         disp(['Label: ',num2str(DF.Label)])
         disp(['Number of Channels: ',num2str(DF.NumChannels)])
         disp(['Data: ',DF.LoadMsg])
         wp = sprintf('%0.2f',DF.WellPosn);
         disp(['Well Position: ',wp])
         pd = sprintf('%0.2f',DF.PenetrationDepth);
         disp(['Penetration Depth: ',pd])
         disp('-------------------------')
      end
      
      function printWellInfo(DF)
         disp('-------------------------')
         wp = sprintf('%0.2f',DF.WellPosn);
         disp(['Well Position: ',wp])
         disp(['Additional Info: \n',DF.WellData])
         disp('-------------------------')
      end
      
      function printPenDepthInfo(DF)
         disp('-------------------------')
         pd = sprintf('%0.2f',DF.PenetrationDepth);
         disp(['Penetration Depth: ',pd])
         disp(['Additional Info: \n',DF.PenData])
         disp('-------------------------')
      end
   end
   methods (Static)
      function obj = loadobj(s)
         if isstruct(s)
            DF.Path = s.path;
            DF.Label= s.label;
            DF.NumChannels= s.channel;
         else
            obj.LoadListener = DataManager.addData(s);
         end
      end
   end
end