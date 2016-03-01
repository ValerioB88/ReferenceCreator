%here we will take the list of references, find it on mendeley, compare the
%result with the original list. ETC
%refStr is a struct with two attribute: the string and the flag;
%0=No good match
%1=OK
%2=multiple entry
function [refStr]=createReference(list,varargin)
p=inputParser;
addParamValue(p, 'discipline',[]);
parse(p, varargin{:});
discipline=p.Results.discipline;

%===TESTING AND DEBUGGING====
%list={'Green','1975'; 'Aternberg, Wilckinson & Sharp', '1969'; 'Pachella', '1974'; 'Green & Swets','1966'; 'Sternberg', '1969'; 'Wickelgren','1977';'LaBerge','1962';'Luce','1986';'Vickers et al.','1971'};
%list={'Taylor','1981';'Lepingle','1994';'Cox & Miller','1970'; 'Tanner','1966'; 'Hanes & Schall','1996'; 'Ratcliff', '2001';'Luce','1986';'Ratcliff','1978'; 'Ratcliff & Rouder','1998'; 'asdasda','asd';'Ratcliff, Van Zandt, & McKook', '1999'};
%list={'Rongo, Spataro, et al.', '2008'};
%list={'Ratcliff','2001'};
%list={'Botvinick et al.'                                     '1999';
%    'Botvinick, Nystrom, Fissell, Carter, & Cohen'         '1999'};
%list={'Meyer et al.', '1988'}
%===
%}

%check for duplicate and eliminates duplicates
[~,idx]=unique(strcat(list(:,1),list(:,2)), 'rows');
list=list(idx,:)

%for each element in the authorList, find X=2 papers (X=numRef, you can change it)
for i=1:size(list,1)
    [ref{i}, found]=findPaper(list{i,1},'year',list{i,2},'discipline', discipline,'numR',2);
    
    if found==0
        refStr{i}.string=[list{i,1} ', ' list{i,2} ': nothing found for this entry. Please check the spelling'];
        refStr{i}.flag=0;
    else
        
        %FIND PERFECT MATCH
        findMatch=[];
        [autCell, etAlBool]=authorCell(list{i,1});
        for xx=1:length(ref{i})
            
            flagNoMatch=0;
            %check if they have the same number of authors
            if (length(ref{i}{xx}.authors)>length(autCell) && etAlBool==1 || (length(ref{i}{xx}.authors)==length(autCell) && etAlBool==0))
                %comparable. Now compare. If there is a no match, change flag
                %and break.
                for yy=1:length(autCell)
                    if ~strcmp(regexprep(ref{i}{xx}.authorsSurname{yy},'[^a-zA-Z]*',''),regexprep(autCell{yy},'[^a-zA-Z]*',''))
                        flagNoMatch=1; break;
                    end
                end
                if flagNoMatch==0
                    findMatch=[findMatch xx];
                end
                
            else
                continue;
            end
            
        end
        
        %no match found.
        if isempty(findMatch)
            %we will suggest maximum two papers.
            autStr1=autCellStr(ref{i}{1}.authors, 'name',0);
            
            if length(ref{i})>=2
                autStr2=autCellStr(ref{i}{2}.authors,'name',0);
                refStr{i}.string=[list{i,1} ', ' list{i,2} ': no good match found. Maybe you meant ' autStr1 ', ' ref{i}{1}.date ' or ' autStr2 ', ' ref{i}{2}.date '?'];
            else
                refStr{i}.string=[list{i,1} ', ' list{i,2} ': no good match found. Maybe you meant ' autStr1 ', ' ref{i}{1}.date '?'];
            end
            refStr{i}.flag=0;
            refStr{i}.doi='';
        end
        %more than one match found
        if size(findMatch,2)>1
            refStr{i}.string=[list{i,1} ', ' list{i,2} ': Two or more matches found. Please check carefully the following: '];
            for zz=1:size(findMatch,2)
                refStr{i}.string=[refStr{i}.string '      ******' ref{i}{findMatch(zz)}.sAPA];
            end
            refStr{i}.flag=2; refStr{i}.doi='';
        end
        %perfect match.
        if size(findMatch,2)==1
            refStr{i}.string=ref{i}{findMatch}.sAPA;  refStr{i}.flag=1;  refStr{i}.doi=ref{i}{findMatch}.doi;
        end
    end
end

%{
==debug
%display(refStr);
for i=1:length(refStr)
    display(refStr{i}.string);
end
%}
end

