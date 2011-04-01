clear variables
zac = 1;
tic
cele = [100:109, 111:119, 121:124, 200:203, 207:210, 212:215];
%% NACTENI DAT
% a jejich nasledne nacpani do jedne matice
for k = [113:119]
    num = num2str(k);
    Y = OPEN_CUT_DATA(['MITann_data/' num '_00:30:00']); %nacte data
    % cely soubor rozdelim na 'deleni' casti a vemu v potaz jen 'l'ou cast
    l = 5;
    deleni = 20;
    Y = Y(floor((l-1)*size(Y,1)/deleni+1):floor((l)*size(Y,1)/deleni),:);
    % presamplovani
    f = 100; % frekvence pro novy sample, nejlepe delitelna dvaceti
    Y = INTERP(Y,f+f/5); % presampluje
    Y = Y(:,f/10+1:end-f/10);
    
    if zac == 1
        Z = NORM(Y);
        zac = 2;
    else
        Z = [Z;NORM(Y)];
    end
end

%% Zamicham matice vzoru
permutation = randperm(size(Z,1));
TMP = Z;
for l = 1:size(Z,1)
    TMP(l,:) = Z(permutation(l),:);
end
Z = TMP;
clear TMP
%{
%% odecteni medianu
tmp = median(Z,2);
for k = 1:size(Z,1)
    Z(k) = Z(k) - tmp(k);
end
Z = NORM(Z);
%}
%% Vykresleni vsech signalu pres sebe
if 1
    figure(1)
    subplot(121)
    plot(Z')
    title(['MIT-' num2str(k) 'sampled to ' num2str(f)])
end

%% SAMOORGANIZACE
subplot(122)
%[W H] = SOM(Z,10,1,50,  0.5, 1000, 1000, 0.001, 10);
       %SOM(X, a,b, T, eta0, tau1, tau2,    B,   C)
for t = 1:1000
    
    [W E] = LLOYD(Z,10,1);
    Ws{t} = W;
    Ers(t) = E;
    disp([num2str(t)])

end
[a s] = min(Ers);
W = Ws{s};
E = Ers(s);
Ers    
W = Ws{s};
E = Ers(s);
%% Vykresleni sitovych vektoru
if 1    
    plot(W')
    title(['MIT-' num2str(k) ' downsampled to ' num2str(f) ' with error = ' num2str(E)]);
end
disp (['MIT-' num2str(k) ' done.'])
toc