%take an author list, in the form of eg. Author1, Author2 & Author3 - or
%Author1 & Author2, or Author1 et al. etc and return a cellarray where each
%cell is a different author. EtAlBool is set to one if "et al." is present.
%
function [authorCellProc, etAlBool]=authorCell(authorList)
etAlBool=0;
authorCellProc=regexp(strtrim(regexprep(authorList,'[, ]*et al[.]*','')), '[&,]', 'split'); %each cell an author
for i=length(authorCellProc):-1:1
    authorCellProc{i}=strtrim(authorCellProc{i});
    if strcmp(authorCellProc{i},'') %get rid of white spaces
        authorCellProc(i)=[];
    end
end
counterAuthor=length(authorCellProc);
%if it's written like X, Y, et al., we have to take one out
%autCell=cellfun(@(cell) regexprep(cell,'et al[.]*','') ,autCell,'un',0);
authorCellProc=cellfun(@(cell) strtrim(cell), authorCellProc, 'un',0); %take out the leading spaces, if any
%%surnameGIVEN=surnameGIVEN;

%is there "et al."?
if (~isempty(strfind(authorList, 'et al')) ||   ~isempty(strfind(authorList, 'et al.')))  etAlBool=1; end

end 