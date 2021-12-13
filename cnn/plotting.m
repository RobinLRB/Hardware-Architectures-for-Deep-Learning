clc
clear

%%modifying c1
c1 = [6 8 10 12];
accuracy=[55 56 56 55];
figure(1)
bar(c1, accuracy);
ylabel('Accuracy');
xlabel('The number of feature maps in C1');

%%modifying c3
c3 = [16 20 24 28];
accuracy=[55 54 58 56];
figure(2)
bar(c3, accuracy);
ylabel('Accuracy');
xlabel('The number of feature maps in C3');

%%layers
layer = [7 9 11 13];
accuracy=[55 54 36 23];
figure(3)
bar(layer, accuracy);
ylabel('Accuracy');
xlabel('Total layers of CNN');

%%Activation function
figure(4)
X = categorical({'ReLu','Sigmoid','tanh'});
X = reordercats(X, {'ReLu','Sigmoid','tanh'});
accuracy = [61 10 60];
bar(X,accuracy,0.5)

%set(gca,'XTickLabel',{'  ','ReLu',' ','Sigmoid',' ','Tanh',' '});