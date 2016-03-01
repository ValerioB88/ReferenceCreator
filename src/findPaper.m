%find ONE citation. Can return more than one paper. You can specify more
%than one author. The authorsList HAS to be in the format 'SURNAME' or
%'SURNAME N.' or 'SURNAME N., SURNAME N.,'
function [ref,found]= findPaperV2(authorList, varargin)

h=[]; ref=[];
p=inputParser;
%number of reference that it tries to find
addParamValue(p, 'numR',2);
%years: STRING
addParamValue(p, 'year','');
%discipline
addParamValue(p, 'discipline',[]);


parse(p, varargin{:});
numR=p.Results.numR;
disc=p.Results.discipline;
year=p.Results.year;
%==testing
%authorList='Goldman-Rakic';
%year=1995;
%===
if ~ischar(year)  year= num2str(year);  end %year from now on is a string

errorString=[authorList ',' year ': no match found'];

[authorCellProc,etAlBool]=authorCell(authorList); 

%FORMAT AUTHOR
strAuthor=['&author='];
for i=1:length(authorCellProc)
    if i>1
        strAuthor=[strAuthor '%2C'];
    end
    tempString=authorCellProc{i}; tempString(tempString==' ')='+'; %autCell{i}(autCell{i}==' ')='+';
    strAuthor=[strAuthor tempString];
end
strAuthor=strrep(strAuthor,'et+al','');

%FORMAT DISCIPLINE
%for more than one
%{
strDisc=[];
for i=1:length(disc)
    if i==1
        strDisc=['&disciplines=selected'];
    end
    disc(disc==' ')='+';
    strDisc=[strDisc '&discipline=' disc{i}];
end
%}
strDisc=['&disciplines=selected'];
disc(disc==' ')='+';
strDisc=[strDisc '&discipline=' disc];

%FORMAT YEAR
strYear=[];
if ~isempty(year)
    if regexp(year,'[a-b]*')
        warning([authorList ', ' year ' : Years with letter not supported yet. Letter ignored. WATCH OUT']);
        year= regexp(year,'[a-b]*','split'); year=year{1};
    end
    strYear=['&date=range&yearfrom=' num2str(year) '&yearto=' num2str(year)];
end

wholeString=(['http://www.mendeley.com/research-papers/search/?query=' strAuthor strYear strDisc ]);
wholeString=regexprep(wholeString, '[^\x00-\x7F]+',''); %HORRIBLE.
try
    webpageQuery = webread(wholeString);
catch err
    warning([authorList ', ' year ': some Error has accoured during the opening the webpage']); sAPA{1}=errorString; return;
end

result=regexpi(webpageQuery, '<a  href="/(research|catalog)/[^/]*/" title', 'match'); result=cellfun(@(cell) cell(11:end-6), result,'un',0);

if isempty(result)
    warning([authorList ', ' year ': no paper found for']); 
    sAPA{1}='no paper found';
    found=0; ref=0; sAPA=0;
    return;
else
    found=1; 
end 
result=cellfun(@(cell) cell(1:end-1),result,'un',0); %take out the final citation quote "

NUMREF=0; ATTEMPT=0;

if numR>length(result), numR=length(result); end
maxPage=20;
if length(result)<maxPage,  maxPage=length(result); end

%cycle until we found numR papers with different doi (check later) or we
%reach the maxPage, the max number of papers in a page
%(which is 20 by default in Mendeley). 
while (NUMREF<numR  && ATTEMPT<maxPage)
    
    ATTEMPT=ATTEMPT+1;
    try
        webpageQuery = webread(['http://www.mendeley.com' result{ATTEMPT}]);
    catch err
        warning(['Unable to open the following: ' result{ATTEMPT}]);
        continue;
    end
    
    %TAKE REFERENCE FROM THE META DATA
    authors=regexpi(webpageQuery, '<meta name="dc.creator" content="[^"]*">' , 'match');
    title=regexpi(webpageQuery, '<meta name="citation_title" content="[^"]*">' , 'match');
    volume=regexpi(webpageQuery, '<meta name="citation_volume" content="[^"]*">' , 'match');
    date=regexpi(webpageQuery, '<meta name="citation_date" content="[^"]*">' , 'match');
    issn= 	regexpi(webpageQuery, '<meta name="citation_issn" content="[^"]*">' , 'match');
    doi= regexpi(webpageQuery, '<meta name="citation_doi" content="[^"]*">' , 'match');
    issue= 	regexpi(webpageQuery, '<meta name="citation_issue" content="[^"]*">' , 'match');
    firstpage=regexpi(webpageQuery, '<meta name="citation_firstpage" content="[^"]*">' , 'match');
    lastpage=regexpi(webpageQuery, '<meta name="citation_lastpage" content="[^"]*">' , 'match');
    journalT=regexpi(webpageQuery, '<meta name="citation_journal_title" content="[^"]*">' , 'match');
    all={authors title volume date issn doi issue firstpage lastpage journalT};
    
    %tempInf(ormation) is just a temporal variable, we will put everything
    %in the structure reference ref{NUMREF}
    tempInf=cellfun(@(bigcell)  cellfun(@(inscell)  strsplit(inscell,'content="'),bigcell ,'un',0), all, 'un',0);
    tempInf=cellfun(@(bigcell)  cellfun(@(inscell)  inscell(2),bigcell ,'un',0), tempInf, 'un',0);
    tempInf=cellfun(@(bigcell)  cellfun(@(inscell)  inscell{1}(1:end-2),bigcell ,'un',0), tempInf, 'un',0);
    tempInf=cellfun(@(cell) helpFun(cell), tempInf, 'un',0);
    
    %check with the doi if this paper has been found already
    if ATTEMPT>1 && NUMREF>=1 && any(strcmp(ref{1:end}.doi,tempInf{6}{:}))
        continue;
    end 
    
    
    NUMREF=NUMREF+1;
    
    %NOW YOU HAVE THE FORMATTED REFERENCES
    ref{NUMREF}.authors=tempInf{1}; ref{NUMREF}.title=tempInf{2}{:}; ref{NUMREF}.volume=tempInf{3}{:}; ref{NUMREF}.date=tempInf{4}{:};
    ref{NUMREF}.issn=tempInf{5}{:}; ref{NUMREF}.doi=tempInf{6}{:}; ref{NUMREF}.issue=tempInf{7}{:}; ref{NUMREF}.firstpage=tempInf{8}{:};
    ref{NUMREF}.lastpage=tempInf{9}{:}; ref{NUMREF}.journalT=tempInf{10}{:};
    if ~strcmp(ref{NUMREF}.title(end),'.')
        ref{NUMREF}.title(end+1)='.';
    end
    
    
    %REORGANIZE THE NAMES
    allAuthorFoundStr=[];
    for i=1:length(ref{NUMREF}.authors)
        %we will fill this soon
        ref{NUMREF}.authorsInitial{i}=[];
        cellaut=ref{NUMREF}.authors{i};
        cellaut=strtrim(cellaut);
        names=strsplit(cellaut, ' ');
        authorCellFound{i}=[names{end} ','];
        ref{NUMREF}.authorsSurname{i}=names{end};
        for x=1:(length(names)-1)
            try
            authorCellFound{i}=[authorCellFound{i} ' ' names{x}(1) '.'];
            catch
                a=1;
            end 
            ref{NUMREF}.authorsInitial{i}=[ref{NUMREF}.authorsInitial{i} names{x}(1) '.']; %notice the space. If you have to compare later, take it out.
        end
        if i~=length(ref{NUMREF}.authors)
            allAuthorFoundStr=[allAuthorFoundStr authorCellFound{i} ', '];
        else
            allAuthorFoundStr=[allAuthorFoundStr authorCellFound{i}];
        end
        
        
    end
    %add the full stop ad the end.
    if ~strcmp(title{1}(end), '.')
        title{1}(end+1)='.';
    end
    
    %build string
    sAPA{NUMREF}=[allAuthorFoundStr ' (' num2str(ref{NUMREF}.date) '). ' num2str(ref{NUMREF}.title) ' '   num2str(ref{NUMREF}.journalT) ];
    if ~isempty(volume)
        sAPA{NUMREF}=[sAPA{NUMREF} ', ' num2str(ref{NUMREF}.volume)];
    end
    if ~isempty(issue)
        sAPA{NUMREF}=[sAPA{NUMREF} '(' num2str(ref{NUMREF}.issue) ')'];
    end
    if ~isempty(firstpage)
        sAPA{NUMREF}=[sAPA{NUMREF} ' ' num2str(ref{NUMREF}.firstpage)];
    end
    if ~isempty(lastpage)
        sAPA{NUMREF}=[sAPA{NUMREF} '-' num2str(ref{NUMREF}.lastpage)];
    end
    if ~isempty(doi)
        sAPA{NUMREF}=[sAPA{NUMREF} '. doi:' num2str(ref{NUMREF}.doi)];
    end
    
    ref{NUMREF}.sAPA=sAPA{NUMREF};
end
if isempty(ref)
    warning([authorList ', ' year ': no paper found for']); 
    sAPA{1}='no paper found';
    found=0; ref=0; sAPA=0;
end

function cell=helpFun(cell)
if isempty(cell)
    cell={' '};
end

