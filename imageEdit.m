%% intro
% stergem datele din workspace si inchidem toate ferestrele
clc
close all
%citim poza
imdata = imread('s2.jpg');
%aducem poza intr-o dimensiune acceptata de noi
imdata= imresize(imdata, [860, 860]);
%setam parametrii pe care ii folosim
max1=size(imdata,1);
max2=size(imdata,2);
fillvalue=255;
deletevalue=0;
bordervalue=30;
%% elimanre zona galbena, cea ce prezinta in ce ipostaza corpul uman statea --> face probleme
for i=ceil(max1*0.7):1:max1-1
    for j=max2:-1:ceil(max1*0.8)
           if(imdata(i,j,1)>140 && imdata(i,j,2)>140  )
            imdata(i,j,:)=[0,0,0];
           end        
    end
end
%% intro - continuare
% facem o copie a pozei
imdata_copy=imdata;
% facem poza alb negru
imdata=rgb2gray(imdata);
% afisam poza
figure(2)
subplot(2,2,1)
imshow(imdata)
title('image')
%% eliminare plusuri -> Acestea se mascheaza cu o parte neagra
% Legenda din stanga -> aici se limina tot ce se afla in partea treapta si
% este un surplus de informatie ( acea scara de gri)
 for i=2:1:max1-55/100*max1
    for j=2:1:max2-94.4/100*max2
            imdata(i,j)=deletevalue; 
    end
 end
%cod sus -> aici se taie partea cu codul de sus
 for i=2:1:max1-87/100*max1
    for j=2:1:max2  
      %Fara comentariu:algoritmul agresiv Cu comentariu: algoritmul usor
      %if (imdata(i,j) >100)      
        imdata(i,j)=deletevalue;
     % end
    end
 end
% Pentru algoritmul agresiv, se realizeaza bordura de sus 
  for j=2:1:max2   
           imdata(i,j)=bordervalue;
  end
 %Scara din dreapta -> se mascheaza acea scara din dreapta
 %Versiunea 1 Algoritmul agresiv
 for i=2:1:max1-1
    for j=max2:-1:max2-max2*6/100
            imdata(i,j)=deletevalue;     
    end
 end
 %Versiunea 2 Algoritmul usor
%   for i=2:1:max1
%     for j=max2:-1:max2-max2*6/100
%         if(imdata(i,j)>80)
%             imdata(i,j)=deletevalue;
%         end
%     end
%  end

%% bordura ecografie -> se realizeaza bordurarea ecografiei
primulx=0;
primuly=ceil(max2-0.9*max2);
josI=size(imdata,1)-1;
j=ceil(size(imdata,2)/2);
% Se cauta de jos in sus, pe orizontal la mijloc, primul pixel ce nu e 
% negru absolut
while imdata(josI,j)<5   
    josI = josI-1;   
end
% Partea din stanga
% Se cauta de sus in jos, pe verticala, primul pixel
for i=3:1:max1
   if imdata(i,primuly)>5 && imdata(i,primuly)~=bordervalue
           primulx=i;
           break;
   end 
end
j=primuly;
% Se realizeaza bordura din partea stanga conform ecuatiei y= x%2? x:x-1
for i=primulx:1:max1
    if(j>0)
    imdata(i,j)=bordervalue;
        if(mod(i,2)==1)
            j=j-1;
        end
        conturi2=i;
        conturj2=j;
    end
end
j=primuly;
for i=primulx:-1:1
    if(j<max2)
    imdata(i,j)=bordervalue;
        if(mod(i,2)==1)
            j=j+1;
        end
    end
end
%partea din dreapta
ultimulx=0;
ultimuly=ceil(0.9*max2);
% Se cauta de sus in jos, pe verticala, primul pixel
for i=3:1:max1
   if imdata(i,ultimuly)>5 && imdata(i,primuly)~=bordervalue
           ultimulx=i;
           break;
   end
   
end
j=ultimuly;
% Se realizeaza bordura din partea dreapta conform ecuatiei y= x%2? x:x-1
for i=ultimulx:1:max1
    if(j<max2)
    imdata(i,j)=bordervalue;
        if(mod(i,2)==1)
            j=j+1;
        end
        conturi1=i;
        conturj1=j;
    end
end
j=ultimuly;
for i=ultimulx:-1:1
    if(j>0)
    imdata(i,j)=bordervalue;
        if(mod(i,2)==1)
            j=j-1;
        end
      
    end
end
% Se realizeaza a doua metoda de bordurare pentru partea stanga
for i=2:size(imdata,1)-1
    for j=2:size(imdata,2)-1
        if(imdata(i,j)>15 && imdata(i,j)~=bordervalue)
            imdata(i,j-1)=bordervalue;
            imdata(i,j)=bordervalue;
            imdata(i-1,j)=bordervalue;
            imdata(i-1,j-1)=bordervalue;
            break;
        end
    end
end
% Se realizeaza a doua metoda de bordurare pentru partea dreapta
for i=2:size(imdata,1)
    for j=size(imdata,2):-1:2
        if(imdata(i,j)>15 && imdata(i,j)~=bordervalue)
            imdata(i,j-1)=bordervalue;
            imdata(i,j)=bordervalue;
            imdata(i-1,j)=bordervalue;
            imdata(i-1,j+1)=bordervalue;
            break;
        end
    end
end
% Se realizeaza a doua metoda de bordurare pentru partea de jos
for j=2:size(imdata,2)
    for i=size(imdata,1)-1:-1:2
        if(imdata(i,j)>15 && imdata(i,j)~=bordervalue)
            imdata(i,j-1)=bordervalue;
            imdata(i,j)=bordervalue;
            imdata(i-1,j)=bordervalue;
            imdata(i-1,j+1)=bordervalue;
            break;
        end
    end
end
% Se cauta primul pixel (exceptand bordura de sus) din dreapta de sus ce e
% de valoarea bordurii
count = 0;
for stangaISus=1:size(imdata,1)
    if(imdata(stangaISus,2)==bordervalue)
         count = count + 1;
    end
    if(count == 2)
        break;
    end
    
end
% Se cauta primul pixel din stanga de jos ce e de valoarea bordurii
for stangaIJos=size(imdata,1):-1:1
    if imdata(stangaIJos,2)==bordervalue
        break
    end
    
end
% Se unesc cele doua puncte
for i=stangaISus:stangaIJos
    imdata(i,2)=bordervalue;
end
j= ceil( max2-max2*6/100 -1);
count = 0;
% Se cauta primul pixel (exceptand bordura de sus) din dreapta de sus ce e 
% de valoarea bordurii
for drISus=1:max1
    if(imdata(drISus,j)==bordervalue)
        count = count + 1;
    end
    if(count == 2)
        break;
    end
    
end
% Se cauta primul pixel din dreapta de jos ce nu e de valoarea bordurii
for drIJos=max1:-1:1
    if imdata(drIJos,j)==bordervalue
        break
    end
    
end
% Se unesc cele doua puncte
for i=drISus:drIJos
    imdata(i,j)=bordervalue;
end
% % Curba de jos
% % Metoda 1-Spline Liniar - Nefunctuionala
% % for x=1:1:max2
% % if(x>=0 && x<=0.095*max2)
% %     y=(-5.3453*1e-5)*x^3+(1.0443*1e-2)*x^2-(5.7857*1e-2)*x+(5.41*1e+2);
% % else
% %     if(x>0.095*max2 && x<=0.253*max2)
% %         y=(5.7646*1e-6)*x^3-(4.1248*1e-3)*x^2+(1.1367*x)+(5.0835*1e+2);
% %     else
% %         if(x>0.253*max2 && x<=0.399*max2)
% %             y=(1.3362*1e-7)*x^3-(4.2522*1e-4)*x^2+(3.2647*1e-1)*x+(5.6749*1e+2);
% %         else
% %             if(x>0.399*max2 && x<=0.517*max2)
% %                 y=(-1.2829*1e-6)*x^3+(1.0409*1e-3)*x^2-(1.7933*1e-1)*x+(6.2566*1e+2);
% %             else
% %                 if(x>0.517*max2 && x<=0.661*max2)
% %                     y=(8.8563*1e-7)*x^3-(1.7500*1e-3)*x^2+(1.0180)*x+(4.5445*1e+2);
% %                 else
% %                     if(x>0.661*max2 && x<=0.787*max2)
% %                         y=(-1.3683*1e-6)*x^3+(2.1110*1e-3)*x^2-(1.1867)*x+(8.7407*1e+2);
% %                     else
% %                         if(x>0.787*max2 && x<=0.925*max2)
% %                             y=(-4.6967*1e-6)*x^3+(8.9009*1e-3)*x^2-(5.8038)*x+(1.9206*1e+3);
% %                         else
% %                             if(x>0.925*max2 && x<=max2)
% %                                 y=(6.6665*1e-5)*x^3-(1.6215*1e-1)*x^2+(1.3087*1e+2)*x-(3.4480*1e+4)-2;
% %                             end
% %                         end
% %                     end
% %                 end
% %             end
% %         end
% %     end
% % end
% % y=ceil(y);
% % imdata(y,x)=bordervalue;
% % end
%% contur poza
% pentru a elimina partea neagra ce nu contine ecografia este nevoie ca
% initial marginea pozei sa fie de valoarea dorita sa fie pusa, in cazul de
% fata 255
for i=1:1:max1
    imdata(i,1)=fillvalue;
    imdata(i,max2)=fillvalue;
end
 for j=1:1:max2
    imdata(1,j)=fillvalue;
    imdata(max1,j)=fillvalue;   
 end
%% expansiunea marginii
power = 2;% de cate ori se executa algoritmul
while power >=1
    % Se parcurge matricea de la stanga la dreapta si de sus in jos, daca
    % un pixel are in vinatatea lui ( sus sau la stanga) un pixel de
    % valoarea umplurii si daca el are valoarea mai mica decat 10 ( dar in
    % esenta mai mica decat bordura) acesta devine alb
    for i=2:1:max1
        for j=2:1:max2
            if(imdata(i,j)<=10 && (imdata(i-1,j)==fillvalue || imdata(i,j-1)==fillvalue) )
                imdata(i,j)=fillvalue;
                continue
            end
        end
    end
    % Se parcurge matricea de la dreapta la stanga si de sus in jos, daca
    % un pixel are in vinatatea lui ( sus sau la dreapta) un pixel de
    % valoarea umplurii si daca el are valoarea mai mica decat 10 ( dar in
    % esenta mai mica decat bordura) acesta devine alb
    for i=max1-1:-1:2
        for j=max2-1:-1:2
            if(imdata(i,j)<=10 && (imdata(i+1,j)==fillvalue || imdata(i,j+1)==fillvalue) )
                imdata(i,j)=fillvalue;
                continue
            end
        end
    end
power = power-1;
end
% se afiseaza figura obtinuta dupa bordurare
figure(2)
subplot(2,2,2)
imshow(imdata)
title('zona de interes')
%% o masca pe nievele
% Se cauta valoarea maxima in matrice, ce difera de valoarea bordurii
maxi=0;
for i=1:max1
    for j=1:max2
        if imdata(i,j)~=fillvalue && imdata(i,j)>maxi
            maxi= imdata(i,j);
        end
    end
end
% Se realizeaza nivelarea matricei pe mai multe nivele, nivelele alese
% pentru nivelare sunt alese de mine astfel :
% 200 E [Max 0.8*Max]          70 E [0.4*Max 0.375*Max]
% 150 E [0.8*Max 0.6*Max]      65 E [0.375*Max 0.35*Max]
% 110 E [0.6*Max 0.55*Max]     60 E [0.35*Max 0.3*Max]
% 100 E [0.55*Max 0.5*Max]     50 E [0.3*Max 0.2*Max]
% 90  E [0.5*Max 0,4*Max]      20 E [0.2*Max 0]
for i=1:max1
    for j=1:max2
        if imdata(i,j)~=fillvalue && imdata(i,j)<= maxi && imdata(i,j)>maxi*0.8
            imdata(i,j)=200;
        elseif imdata(i,j)~=fillvalue && imdata(i,j)<= maxi*0.8 && imdata(i,j)>maxi*0.6
            imdata(i,j)=150;
         elseif imdata(i,j)~=fillvalue && imdata(i,j)<= maxi*0.6 && imdata(i,j)>maxi*0.55
            imdata(i,j)=110;
        elseif imdata(i,j)~=fillvalue && imdata(i,j)<= maxi*0.55 && imdata(i,j)>maxi*0.5
            imdata(i,j)=100;
         elseif imdata(i,j)~=fillvalue && imdata(i,j)<= maxi*0.5 && imdata(i,j)>maxi*0.4
            imdata(i,j)=90;
         elseif imdata(i,j)~=fillvalue && imdata(i,j)<= maxi*0.4 && imdata(i,j)>maxi*0.375
            imdata(i,j)=70;
         elseif imdata(i,j)~=fillvalue && imdata(i,j)<= maxi*0.375 && imdata(i,j)>maxi*0.35
            imdata(i,j)=65;
         elseif imdata(i,j)~=fillvalue && imdata(i,j)<= maxi*0.35 && imdata(i,j)>maxi*0.3
            imdata(i,j)=60;
         elseif imdata(i,j)~=fillvalue && imdata(i,j)<= maxi*0.3 && imdata(i,j)>maxi*0.2
            imdata(i,j)=50;
         elseif imdata(i,j)~=fillvalue && imdata(i,j)<= maxi*0.2 && imdata(i,j)>0
            imdata(i,j)=20;
        end 
    end
end
% Se afiseaza figura obtinuta dupa nivelare
figure(1)
imshow(imdata)
title('Imaginea pe nivele')
%% expansiunea conturului
% Se realizeaza o matrice cu valori de 1 si 0 pentru a vedea unde am fost
% si unde nu am fost deja, 1 - nu am fost 0 - am fost
mem1=ones(max1,max2);
% Se realizeaza o extindere a petei de valoare 150 peste petele de valoare
% pana in 80 pe baza algoritmului prezentat in functia expand
for i=2:1:max1
    for j=2:1:max2
        if(imdata(i,j)== 150)
            [imdata,mem1]=expand(imdata,mem1,i,j,max1-1,max2-1,80,150);
        end
    end
end
% Am decis sa folosesc o alta matrice in care sa verific unde am fost si
% unde nu, pentru a putea extinde pata de 200 peste cele de 150
mem2=ones(max1,max2);
for i=2:1:max1
    for j=2:1:max2
        if(imdata(i,j)== 200)
            [imdata,mem2]=expand(imdata,mem2,i,j,max1-1,max2-1,105,200);     
        end
    end
end
% Realziam o matrice ce contine valorile petelor obtinute
mem=and(mem1,mem2);
% Se afiseaza expansiunea petelor "dominante"
figure(2)
subplot(2,2,3)
imshow(imdata)
title('Selectia petelor')
%% Afisare pata
% Cautam in imagine pixelii ce contin valoarea 150 si 200 si ii coloram in
% copia imaginii astfel incat pentru 200 sa avem culoarea rosu si pentru
% 150 culoarea verde
for i=2:1:max1
    for j=2:1:max2
        if(imdata(i,j)== 200)
            imdata_copy(i,j,:)=[255,0,0];
        end
        if(imdata(i,j)== 150)
            imdata_copy(i,j,:)=[0,255,0];    
        end
    end
end
% Afisam imaginea obtinuta
figure(2)
subplot(2,2,4)
imshow(imdata_copy)
title('Selectia petelor -color')

%% poza color
% Pentru nivelele alese anterior se realizeaza o harta ce se aseamana cu
% cele geografice pentru o intelegere mai buna a radiografiei
for i=2:1:max1
    for j=2:1:max2
        if(imdata(i,j)== 200)
            imdata_copy(i,j,:)=[200,100,0];  
        end
        if(imdata(i,j)== 150)
            imdata_copy(i,j,:)=[150,150,0];    
        end
        if(imdata(i,j)== 110)
            imdata_copy(i,j,:)=[100,200,0];  
        end
        if(imdata(i,j)== 100)
            imdata_copy(i,j,:)=[100,250,0];    
        end
        if(imdata(i,j)== 90)
            imdata_copy(i,j,:)=[50,255,0];    
        end
        if(imdata(i,j)== 70)
            imdata_copy(i,j,:)=[0,255,0]; 
        end
        if(imdata(i,j)== 65)
            imdata_copy(i,j,:)=[0,250,100];
        end
        if(imdata(i,j)== 60)
            imdata_copy(i,j,:)=[0,200,100];  
        end
        if(imdata(i,j)== 50)
            imdata_copy(i,j,:)=[0,100,200]; 
        end
        if(imdata(i,j)== 20)
            imdata_copy(i,j,:)=[0,50,235];  
        end   
        if(imdata(i,j) == 0 || imdata(i,j) == fillvalue)
            imdata_copy(i,j,:)=[0,0,255];  
        end  
    end
end
% Se afiseaza imaginea obtinuta
figure(3)
imshow(imdata_copy)
title('harta nivelelor color')
% Next research: convex/concavHull -> pentru realziarea conturului petelor
% obtinute