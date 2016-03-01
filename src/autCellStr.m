%take an author cell list and change it back to a string
function [autStr]=autCellStr(autCell,varargin)

p=inputParser;
addParamValue(p, 'name',1);

parse(p, varargin{:});
name=p.Results.name;
autStr=[];
if name==1 
    for i=1:length(autCell)
          cellaut=autCell{i};
        names=strsplit(cellaut, ' ');
        authorCellFound{i}=[names{end} ','];
        for x=1:(length(names)-1)
            authorCellFound{i}=[authorCellFound{i} ' ' names{x}(1) '.'];
               end
        if i~=length(autCell)
            autStr=[autStr authorCellFound{i} ', '];
        else
            autStr=[autStr authorCellFound{i}];
        end
        
        
    end
else
     for i=1:length(autCell)
          cellaut=autCell{i};
       
        names=strsplit(cellaut, ' ');
        if i~=length(autCell)
        autStr=[autStr names{end} ', '];
        else 
            autStr=[autStr names{end}];
        end 
    end
end 