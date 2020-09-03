function [a,b]=expand(imdata,mem,i,j,max1,max2,minv,maxv)
% Extindem zona cu valoare maxima in celelalte zone
% Daca un pixel are valoare mai mare sau egal decat minValue si mai mica
% sau egal decat maxValue atunci daca pixelul respectiv are in jurul lui un
% pixel de valoare maxima si daca in matricea in care verificam daca am
% fost sau nu avem valoarea 1 atunci pixelul respectiv devine de valoare
% maxValue si analizam cu acelasi algoritm toti pixelii vecini cu el
if i<max1 && j<max2 && i>1 && j>1 
        if(imdata(i,j)>=minv && imdata(i,j)<maxv+1 && mem(i,j)>0 && (imdata(i+1,j)==maxv || imdata(i-1,j)==maxv ||imdata(i,j-1)==maxv || imdata(i,j+1)==maxv)  )
            imdata(i,j)=maxv;
            mem(i,j)=0;
            [imdata,mem]=expand(imdata,mem,i+1,j,max1,max2,minv,maxv);
            [imdata,mem]=expand(imdata,mem,i-1,j,max1,max2,minv,maxv);
            [imdata,mem]=expand(imdata,mem,i,j-1,max1,max2,minv,maxv);
            [imdata,mem]=expand(imdata,mem,i,j+1,max1,max2,minv,maxv);
            a=imdata;
            b=mem;
        else
            a=imdata;
            b=mem;
        end
else 
     a=imdata;
     b=mem;
end
end

