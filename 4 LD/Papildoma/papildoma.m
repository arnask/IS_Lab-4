features = pozymiai_raidems_atpazinti("raides.jpg", 6);
P = cell2mat(features);
% Output
T = [1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5]

net = newff(P,T,[4 1], {'tansig' 'purelin'},'traingda');
net.trainParam.Epochs = 20;
net.trainFcn = 'trainrp';
net.trainParam.lr = 0.2;
net.trainParam.goal = 1e-5;
net = train(net,P,T);

%% Test of the network (recognizer)
% Extract features of the test image
pavadinimas = 'vardas.jpg';
pozymiai_patikrai = pozymiai_raidems_atpazinti(pavadinimas, 1);
%% Perform letter recognition
P2 = cell2mat(pozymiai_patikrai);
%% Predict
Y2 = sim(net, P2);
raidziu_sk = size(P2,2);
atsakymas = [];
for k = 1:raidziu_sk
    switch round(Y2(k))
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
