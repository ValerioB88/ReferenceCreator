%in case you want to use this program outside the GUI, you can either call
%this function to read a text file, or call findPaper to look for a simple
%paper.

%example: 
%[refCell, htmlREF, plainREF]=readTextFile('test.txt');
% 

% RETURN: refCell, a struct with references
% htmlRef, a html version of the reference list, with bold charachter and different font
% plainRef, a plain text reference list.
% The function will write the plainRef on reference.txt

%Valerio Biscione, 2014 - http://valerio-biscione.psychology-search.com/
function readTextFile(fileName) 
if nargin<1 
    fileName='test.txt';
end 
s=fileread(fileName);


 [refCell, htmlREF, plainREF]=readText(s);
 
%write on textfile
fileID=fopen('referenceList.txt','w'); 
fprintf(fileID, plainREF);
fclose(fileID);

end 