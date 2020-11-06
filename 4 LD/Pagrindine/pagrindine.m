pozymiai = pozymiai_raidems_atpazinti("raides.jpg", 6);
P = cell2mat(pozymiai);
% Output
T = [eye(5), eye(5), eye(5), eye(5), eye(5), eye(5)]; 1
tinklas = newrb(P,T,0,1,13);
%% Test of the network (recognizer)
% Extract features of the test image
pavadinimas = 'vardas.jpg';
pozymiai_patikrai = pozymiai_raidems_atpazinti(pavadinimas, 1);
%% Perform letter recognition
P2 = cell2mat(pozymiai_patikrai);
Y2 = sim(tinklas, P2);
[a2, b2] = max(Y2);
raidziu_sk = size(P2,2);
atsakymas = [];
for k = 1:raidziu_sk
    switch b2(k)
        case 1
            atsakymas = [atsakymas, 'R'];
        case 2
            atsakymas = [atsakymas, 'N'];
        case 3
            atsakymas = [atsakymas, 'A'];
        case 4
            atsakymas = [atsakymas, 'S'];
        case 5
            atsakymas = [atsakymas, 'K'];
    end
end
figure(8), text(0.1,0.5,atsakymas,'FontSize',38), axis off
