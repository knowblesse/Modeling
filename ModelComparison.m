%% Rescorla Wagner Model


%% Constants
alpha = 1;
lambda = 1;
lr_acq = 0.1;
lr_ext = 0.05;

%% Experiemnt Condition
condition = {};
%                  CS          lambda
condition{1} = [ones(100,1), ones(100,1)];
condition{2} = [ones(100,1), 0.5 * ones(100,1)];
condition{3} = [ones(100,1), repmat([0.9,0.1]',50,1)];
condition{4} = [ones(100,1), repmat([0.7,0.3]',50,1)];
condition{5} = [ones(100,1), repmat([1,0]',50,1)];

%% Run
figure(1);
set(gcf,'Position',[0, 0, 1179, 611]);
clf;
hold on;

for e = 1 : 5
    numTrial = 100;
    experiment = condition{e};
    V = zeros(numTrial,1);
    for i = 1 : numTrial
        lambda = experiment(i,2);
        if lambda > 0 % acq
            deltaV = alpha * lr_acq * (lambda - V(i));
        else % ext
            deltaV = alpha * lr_ext * (lambda - V(i));
        end
        V(i+1) = V(i) + deltaV;
    end

    plot(V);
end
legend({...
    'lambda:1',...
    'lambda:0.5',...
    'lambda:oscillate(0.9,0.1)',...
    'lambda:oscillate(0.7,0.3)',...
    'lambda:oscillate(1,0)'
    });
title('Rescorla-Wagner');
%% Mackintosh Model
% Constants
initial_alpha = 0.8;
% learning rate AND "stimulus-specific parameter" : alpha.
% this sometimes referred as saliency



% %% Run
% figure(2);
% clf;
% hold on;
% 
% for e = 1 : 4
%     alpha = initial_alpha;
%     numTrial = 100;
%     experiment = condition{e};
%     V = zeros(numTrial,1);
%     for i = 1 : numTrial
%         lambda = experiment(i,2);
%         if lambda > 0 % acq
%             deltaV = alpha * lr_acq * (lambda - V(i));
%         else % ext
%             deltaV = alpha * lr_ext * (lambda - V(i));
%         end
%         if abs(lambda - V(i)) < abs(lambda - sum(V(i)))
%             deltaAlpha  =  abs(lambda - sum(V(i))) / abs(lambda - V(i));
%         else
%             deltaAlpha = deltaAlpha * 0.9;
%         end
%         V(i+1) = V(i) + deltaV;
%     end
% 
%     plot(V);
% end
% legend({...
%     'lambda:1',...
%     'lambda:0.5',...
%     'lambda:oscillate(0.9,0.1)',...
%     'lambda:oscillate(0.7,0.3)'...
%     });


%% Pearson Hall

initial_alpha = 1;

figure(3);
set(gcf,'Position',[0, 0, 1179, 611]);
clf;
hold on;

for e = 1 : 4
    alpha = initial_alpha;
    numTrial = 100;
    experiment = condition{e};
    V = zeros(numTrial,1);
    for i = 1 : numTrial
        lambda = experiment(i,2);
        if lambda > 0 % acq
            deltaV = alpha * lr_acq * (lambda - V(i));
        else % ext
            deltaV = alpha * lr_ext * (lambda - V(i));
        end
        alpha = abs(lambda - V(i));

        V(i+1) = V(i) + deltaV;
    end

    plot(V);
end
legend({...
    'lambda:1',...
    'lambda:0.5',...
    'lambda:oscillate(0.9,0.1)',...
    'lambda:oscillate(0.7,0.3)'...
    });
title('Pearson-Hall');

%% Esber-Haselgrove
phi = 1;

figure(4);
set(gcf,'Position',[0, 0, 1179, 611]);
clf;
hold on;

for e = 1 : 4
    alpha = initial_alpha;
    numTrial = 100;
    experiment = condition{e};
    V = zeros(numTrial,1);
    V_bar = zeros(numTrial,1);
    for i = 1 : numTrial
        lambda = experiment(i,2);
        if lambda > 0 % acq
            deltaV = alpha * lr_acq * (lambda - (V(i)-V_bar(i)));
            deltaV_bar = alpha * lr_acq * ((V(i)-V_bar(i)) - lambda);
        else % ext
            deltaV = alpha * lr_acq * (lambda - (V(i)-V_bar(i)));
            deltaV_bar = alpha * lr_acq * ((V(i)-V_bar(i)) - lambda);
        end
        epsilon = (V(i) + V_bar(i)) * 10;
        alpha = phi + epsilon;

        V(i+1) = V(i) + deltaV;
        V_bar(i+1) = V_bar(i) + deltaV_bar;
    end

    plot(V);
end
legend({...
    'lambda:1',...
    'lambda:0.5',...
    'lambda:oscillate(0.9,0.1)',...
    'lambda:oscillate(0.7,0.3)'...
    });
title('Esber-Haselgrove');
