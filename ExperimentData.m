classdef ExperimentData < handle

   properties (SetAccess = private)
      Path
      Label
      ChannelNum
      TimePoint
      
      MeanIntensity
      Data
      
      WellPosn
      
      PenDepth
      PcntPenDepth
      ConcChange
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
         DF.ChannelNum= channel;
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
         
        function setPenData(DF,pd, fcn)
            DF.PenDepth= pd(1);
            DF.PcntPenDepth= pd(2);
            DF.ConcChange= pd(3);
            
            DF.PenData = sprintf('Penetration depth calculated using fcn "%s"', fcn);           
        end   
            
      function setMeanIntensity(DF)
         if (strcmp(DF.LoadMsg,'No Data'))
             mi = mean(imread(DF.Path));
         else
             mi = mean(DF.Data);
         end
         DF.MeanIntensity= mi;
      end
      
      function getInfo(DF)
         disp('-------------------------')
         disp(['Path: ',num2str(DF.Path)])
         disp(['Label: ',num2str(DF.Label)])
         disp(['Channel Number: ',num2str(DF.ChannelNum)])
         disp(['Timepoint: ',num2str(DF.TimePoint)])
         disp(['Data: ',DF.LoadMsg])
         wp = sprintf('%0.2f',DF.WellPosn);
         disp(['Well Position: ',wp])
         pd = sprintf('%0.2f',DF.PenDepth);
         disp(['Penetration Depth: ',pd])
         disp('-------------------------')
      end
      
      function getWellInfo(DF)
         disp('-------------------------')
         wp = sprintf('%0.2f',DF.WellPosn);
         disp(['Well Position: ',wp])
         disp(['Additional Info: \n',DF.WellData])
         disp('-------------------------')
      end
      
      function getPenDepthInfo(DF)
         disp('-------------------------')
         pd = sprintf('%0.2f',DF.PenDepth);
         disp(['Penetration Depth: ',pd])
         pctpd = sprintf('%.2f%%',DF.PcntPenDepth*100);
         disp(['Percentage Penetration: ',pctpd])
         cc = sprintf('%0.2f',DF.ConcChange);
         disp(['Concentration Change: ',cc, ' (TODO)'])
         disp(['Additional Info: ',DF.PenData])
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