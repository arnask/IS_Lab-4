function pozymiai = pozymiai_raidems_atpazinti(pavadinimas, pvz_eiluciu_sk)
%%  pozymiai = pozymiai_raidems_atpazinti(pavadinimas, pvz_eiluciu_sk)
% Features = pozymiai_raidems_atpazinti(image_file_name, Number_of_symbols_lines)
% taikymo pavyzdys:
% pozymiai = pozymiai_raidems_atpazinti('test_data.png', 8); 
% example of function use:
% Feaures = pozymiai_raidems_atpazinti('test_data.png', 8);
%%
% Vaizdo su pavyzd�iais nuskaitymas | Read image with written symbols
V = imread(pavadinimas);
figure(12), imshow(V)
%% Raid�i� i�kirpimas ir sud�liojimas � kintamojo 'objektai' celes |
%% Perform segmentation of the symbols and write into cell variable 
% RGB image is converted to grayscale
V_pustonis = rgb2gray(V);
% vaizdo keitimo dvejetainiu slenkstin�s reik�m�s paie�ka
% a threshold value is calculated for binary image conversion
slenkstis = graythresh(V_pustonis);
% pustonio vaizdo keitimas dvejetainiu
% a grayscale image is converte to binary image
V_dvejetainis = im2bw(V_pustonis,slenkstis);
% rezultato atvaizdavimas
% show the resulting image
figure(1), imshow(V_dvejetainis)
% vaizde esan�i� objekt� kont�r� paie�ka
% search for the contour of each object
V_konturais = edge(uint8(V_dvejetainis));
% rezultato atvaizdavimas
% show the resulting image
figure(2),imshow(V_konturais)
% objekt� kont�r� u�pildymas 
% fill the contours
se = strel('square',7); % strukt�rinis elementas u�pildymui
V_uzpildyti = imdilate(V_konturais, se); 
% rezultato atvaizdavimas
% show the result
figure(3),imshow(V_uzpildyti)
% tu�tum� objet� viduje u�pildymas
% fill the holes
V_vientisi= imfill(V_uzpildyti,'holes');
% rezultato atvaizdavimas
% show the result
figure(4),imshow(V_vientisi)
% vientis� objekt� dvejetainiame vaizde numeravimas
% set labels to binary image objects
[O_suzymeti Skaicius] = bwlabel(V_vientisi);
% apskai�iuojami objekt� dvejetainiame vaizde po�ymiai
% calculate features for each symbol
O_pozymiai = regionprops(O_suzymeti);
% nuskaitomos po�ymi� - objekt� rib� koordina�i� - reik�m�s
% find/read the bounding box of the symbol
O_ribos = [O_pozymiai.BoundingBox];
% kadangi rib� nusako 4 koordinat�s, pergrupuojame reik�mes
% change the sequence of values, describing the bounding box
O_ribos = reshape(O_ribos,[4 Skaicius]); % Skaicius - objekt� skai�ius
% nuskaitomos po�ymi� - objekt� mas�s centro koordina�i� - reik�m�s
% reag the mass center coordinate
O_centras = [O_pozymiai.Centroid];
% kadangi centr� nusako 2 koordinat�s, pergrupuojame reik�mes
% group center coordinate values
O_centras = reshape(O_centras,[2 Skaicius]);
O_centras = O_centras';
% pridedamas kiekvienam objektui vaize numeris (tre�ias stulpelis �alia koordina�i�)
% set the label/number for each object in the image
O_centras(:,3) = 1:Skaicius;
% sur��iojami objektai pagal x koordinat� - stulpel�
% arrange objects according to the column number
O_centras = sortrows(O_centras,2);
% r��iojama atsi�velgiant � pavyzd�i� eilu�i� ir raid�i� skai�i�
% sort accordign to the number of rows and number of symbols in the row
raidziu_sk = Skaicius/pvz_eiluciu_sk;
for k = 1:pvz_eiluciu_sk
    O_centras((k-1)*raidziu_sk+1:k*raidziu_sk,:) = ...
        sortrows(O_centras((k-1)*raidziu_sk+1:k*raidziu_sk,:),3);
end
% i� dvejetainio vaizdo pagal objekt� ribas i�kerpami vaizdo fragmentai
% cut the symbol from initial image according to the bounding box estimated in binary image
for k = 1:Skaicius
    objektai{k} = imcrop(V_dvejetainis,O_ribos(:,O_centras(k,3)));
end
% vieno i� vaizdo fragment� atvaizdavimas
% show one of the symbol's image
figure(5),
for k = 1:Skaicius
   subplot(pvz_eiluciu_sk,raidziu_sk,k), imshow(objektai{k})
end
% vaizdo fragmentai apkerpami, panaikinant fon� i� kra�t� (pagal sta�iakamp�)
% image segments are cutt off
for k = 1:Skaicius % Skaicius = 88, jei yra 88 raid�s
    V_fragmentas = objektai{k};
    % nustatomas kiekvieno vaizdo fragmento dydis
    % estimate the size of each segment
    [aukstis, plotis] = size(V_fragmentas);
    
    % 1. Balt� stulpeli� naikinimas
    % eliminate white spaces
    % apskai�iuokime kiekvieno stulpelio sum�
    stulpeliu_sumos = sum(V_fragmentas,1);
    % naikiname tuos stulpelius, kur suma lygi auk��iui
    V_fragmentas(:,stulpeliu_sumos == aukstis) = [];
    % perskai�iuojamas objekto dydis
    [aukstis, plotis] = size(V_fragmentas);
    % 2. Balt� eilu�i� naikinimas
    % apskai�iuokime kiekvienos seilut�s sum�
    eiluciu_sumos = sum(V_fragmentas,2);
    % naikiname tas eilutes, kur suma lygi plo�iui
    V_fragmentas(eiluciu_sumos == plotis,:) = [];
    objektai{k}=V_fragmentas;% �ra�ome vietoje neapkarpyto
end
% vieno i� vaizdo fragment� atvaizdavimas
% show the segment
figure(6),
for k = 1:Skaicius
   subplot(pvz_eiluciu_sk,raidziu_sk,k), imshow(objektai{k})
end
%%
%% Suvienodiname vaizdo fragment� dyd�ius iki 70x50
%% Make all segments of the same size 70x50
for k=1:Skaicius
    V_fragmentas=objektai{k};
    V_fragmentas_7050=imresize(V_fragmentas,[70,50]);
    % padalinkime vaizdo fragment� � 10x10 dyd�io dalis
    % divide each image into 10x10 size segments
    for m=1:7
        for n=1:5
            % apskai�iuokime kiekvienos dalies vidutin� �viesum� 
            % calculate an average intensity for each 10x10 segment
            Vid_sviesumas_eilutese=sum(V_fragmentas_7050((m*10-9:m*10),(n*10-9:n*10)));
            Vid_sviesumas((m-1)*5+n)=sum(Vid_sviesumas_eilutese);
        end
    end
    % 10x10 dyd�io dalyje maksimali �viesumo galima reik�m� yra 100
    % normuokime �viesumo reik�mes intervale [0, 1]
    % perform normalization
    Vid_sviesumas = ((100-Vid_sviesumas)/100);
    % rezultat� (po�mius) neuron� tinklui patogiau pateikti stulpeliu
    % transform features into column-vector
    Vid_sviesumas = Vid_sviesumas(:);
    % i�saugome apskai�iuotus po�ymius � bendr� kintam�j�
    % save all fratures into single variable
    pozymiai{k} = Vid_sviesumas;
end
