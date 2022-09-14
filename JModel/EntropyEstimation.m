%% EntropyEstimation
% Testing script for How Entropy can be estimated during multiple drawal
addpath('helper_function');

NUM_TRIAL = 100;
%% Actual Entropy
figure(1);
clf;
H = shannon([0.7,0.3]);
l1 = line([1,NUM_TRIAL], [H,H]);
l1.Color = 'r';
l1.LineWidth = 2;
l1.LineStyle = '--';
ylim([0,1.2]);
hold on;

%% Step-wise Entropy Estimation
result = rand(NUM_TRIAL,1);
J = zeros(NUM_TRIAL,2);
for i = 2 : NUM_TRIAL
    if result(i) < 0.7
        p = 0.7;
        J(i+1,2) = 1;
    else
        p = 0.3;
        J(i+1,2) = 0;
    end
    J(i+1,1) = i/(i+1)*J(i,1) - 1/(i+1)*log2(p);
end
drawAtOnce = true;
if drawAtOnce
    p1 = plot(J(:,1), 'Color','k','LineWidth',1);
    s1_data = find(result <0.7);
    s2_data = find(result >=0.7);
    s1 = scatter(s1_data,J(s1_data,1),'MarkerFaceColor','r','Marker','o','MarkerEdgeColor','none');
    s2 = scatter(s2_data,J(s2_data,1),'MarkerFaceColor','g','Marker','o','MarkerEdgeColor','none');
else
    p1 = plot(J(1,1), 'Color','k','LineWidth',1);
    s1_data = find(result <0.7);
    s2_data = find(result >=0.7);
    s1 = scatter(s1_data(1),J(s1_data(1),1),'MarkerFaceColor','r','Marker','o','MarkerEdgeColor','none');
    s2 = scatter(s2_data(1),J(s2_data(1),1),'MarkerFaceColor','g','Marker','o','MarkerEdgeColor','none');
    legend([l1,p1,s1,s2],{'True Entropy', 'Estimation', '0.7', '0.3'});

    for i = 2 : NUM_TRIAL
        p1.YData = J(1:i,1);
        s1.XData = s1_data(s1_data<=i);
        s1.YData = J(s1_data(s1_data<=i),1);
        s2.XData = s2_data(s2_data<=i);
        s2.YData = J(s2_data(s2_data<=i),1);
        drawnow;
        pause(0.02);
    end
end

