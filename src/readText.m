% This function will take the text in input, it will format it a little (taking
% out the newlines and useless spaces, it will find the citations using regular expression,
% organize the citations in author list and year, and give everything to the
% citation Creator
% You can also use this function without the GUI, loading the text from a file,
% see readTextFile(fileName)

% RETURN: refCell, a struct with references
% htmlRef, a html version of the reference list, with bold charachter and different font
% plainRef, a plain text reference list

%Valerio Biscione, 2014 - http://valerio-biscione.psychology-search.com/


function [refCell, htmlREF, plainREF]=readText(s,varargin)
p=inputParser;
addParamValue(p, 'discipline',[]);
addParamValue(p, 'expression',[]);
parse(p, varargin{:});
discipline=p.Results.discipline;
expression=p.Results.expression;

if isempty(expression)
    %this expression could be not updated. Refer to the expression in RefCrV1t.m
    expression= '([A-Z][A-Za-z]+[ and&,\-]+){1,6}(et al.,|et al,)?(?(?<=,)( )*|( )*\()(\d{4,4}[,; ]*)+[)]?';
end

%take out from the string newlines and long white spaces.
newstr=[];
for i=1:size(s,1)
    text=regexprep(s(i,:),'\r\n|\n|\r',' '); text=regexprep(text,'[ ]*',' ');
    newstr=strcat(newstr, [' ' text]);
end


%match citations, format the matches (take out parentesis, take out common
%word like see, remove start and ending, replace all the and with &.
matches=regexp(newstr, expression,'match');
matches=regexprep(matches, ' ((\d{4,4})*',', $1');
matches=regexprep(matches, ')|see|for a review','');
matches=cellfun(@removeStartEnd ,matches,'un',0);
matches=cellfun(@(cell) strrep(cell,' and ',' & '), matches,'un',0);

plainREF=[];
htmlREF=[];
%if no citation is found.
authorList={};
if isempty(matches)
    refCell='NO CITATION FOUND'; htmlREF=['No citation match found.']; plainREF=htmlREF;
    return;
end

%===now we will organize the citations in an author list (two columns: the
%first contains author's name, the second the year)
index=1;
for i=1:length(matches)
    if ~strcmp(matches{i},'')
        refTemp=matches{i};
        %if there is more than one year, build a reference name/year
        %for each one
        names=regexp(refTemp,'[0-9]*','split');
        years=regexp(refTemp,'[0-9]*','match');
        
        for xxx=1:length(years)
            authorName{index}=names{1};
            authorName{index}=regexprep(authorName{index},'(e\.g\.)','');
            authorName{index}=removeStartEnd(authorName{index});
            authorYear{index}=years{xxx};
            authorList= vertcat(authorList, {authorName{index}, authorYear{index}});
            refCell{index}=strcat(names, [' ', years{xxx}]);
            index=index+1;
        end
    end
end

%we give the authorList to the createReference, which will return a struct of references.
[refCell]=createReference(authorList,'discipline',discipline);

%check for duplicates.
for i=1:length(refCell)
    refCell{i}.duplicate=0;
    for j=1:length(refCell)
        if j~=i && refCell{i}.flag==1 && refCell{j}.flag==1 && strcmp(refCell{i}.doi,'')
            if strcmp(refCell{i}.doi,refCell{j}.doi)
                refCell{i}.duplicate=1;
            end
        end
    end
end

%refCell is a struct with two attribute: the string and the flag;
%FLAG MEANING
%0=No good match
%1=OK
%2=multiple entry
for i=1:length(refCell)
    if refCell{i}.flag==1
        %htmlREF=[htmlREF '<p><br>' refCell{i}.string '</br></p>'];
        if refCell{i}.duplicate==1
            plainREF=[plainREF '\n' refCell{i}.string '  **THIS MAY BE A DUPLICATE**  check carefully  the citation for this author (expecially when it''s cited with "et al.")'];
            htmlREF=[htmlREF '<p><b>' refCell{i}.string '<u>   **THIS MAY BE A DUPLICATE**   </u> check carefully the citation for this author (expecially when it''s cited with "et al.")</p></br>'];
        else
            plainREF=[plainREF '\n' refCell{i}.string]; htmlREF=[htmlREF '<p>' refCell{i}.string '</p>'];
        end
    end
    if refCell{i}.flag==0
        plainREF=[plainREF '\n' refCell{i}.string];htmlREF=[htmlREF '<p><b><font color="red">' refCell{i}.string '</p></font></b>'];
    end
    if refCell{i}.flag==2
        plainREF=[plainREF '\n' refCell{i}.string]; htmlREF=[htmlREF '<p><b>' refCell{i}.string '</p></br>'];
    end
    
end

end

%remove "," or ";" or " " from the beginning of the string
function [str]=removeStartEnd(str)
exitFlag=0;
while exitFlag==0
    if str(1)==' ' || str(1)==',' || str(1)==';'
        str=str(2:end)
    else
        exitFlag=1
    end
end
exitFlag=0;
while exitFlag==0
    if  str(end)==',' || str(end)==' ' || str(end)==';'
        str=str(1:end-1)
    else
        exitFlag=1
    end
end



end

