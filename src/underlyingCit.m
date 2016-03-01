%this function is used to make the citation bold in the upper left window.
%unfortunately I have to use 
function [htmlTOP,n]=underlyingCit(s,expression)
%s=[];
news=[];

for i=1:size(s,1)
 
    text=regexprep(s(i,:),'\r\n|\n|\r','');
    text=regexprep(text,'[ ]*',' ');
    
    news=strcat(news, [' ' text]);
end
s=news;

%s='(Ratcliff et al., 2001)'
%s='CIAO. asd asd CIAO';

%expression='(CIAO.|CIAO)'
htmlTOP=regexprep(s, expression,'<b>$&</b>');
n=length(regexp(s, expression,'match')); 


end 