import torch
import torch.nn as nn
import torch.nn.functional as F
import torchvision
import torchvision.transforms as transforms
import torch.autograd.profiler as profiler
import torch.optim as optim
import matplotlib.pyplot as plt
import numpy as np
import sys
import os

# MLP Structure using one hidden layer
class MPL_1_hidden(nn.Module):

    def __init__(self, hidden_size):
        super(MPL_1_hidden, self).__init__()
        self.fc1 = nn.Linear(28 * 28, hidden_size)
        self.fc2 = nn.Linear(hidden_size, 10)

    def forward(self, x):
        x = x.view(-1, 28 * 28)
        x = F.relu(self.fc1(x))
        x = self.fc2(x)
        return x

    def name(self):
        return "NLP with 1 hidden layer"


def load_data():
    # Load training data and test data from MNIST
    transform = transforms.Compose(
        [transforms.ToTensor(),
        transforms.Normalize((0,), (1,))])

    trainset = torchvision.datasets.MNIST(root='../data', train=True,
                                            download=True, transform=transform)
    trainloader = torch.utils.data.DataLoader(trainset, batch_size=4,
                                            shuffle=True)

    testset = torchvision.datasets.MNIST(root='../data', train=False,
                                        download=True, transform=transform)
    testloader = torch.utils.data.DataLoader(testset, batch_size=4,
                                            shuffle=False)

    return trainloader, testloader

def train(MLP, trainloader, PATH):
    # Train network
    print('Start training')

    # Number of trianing rounds
    epochs = 20 # Defined as passes in LeNet paper
    for epoch in range(epochs):  # loop over the dataset multiple times
        # Change learning rate based on epoch number
        if epoch < 2:
            learning_rate = 0.0005
        elif epoch < 5:
            learning_rate = 0.0002
        elif epoch < 8:
            learning_rate = 0.0001
        elif epoch < 12:
            learning_rate = 0.00005
        else:
            learning_rate = 0.00001
        print('\n')
        print('Learning rate:', learning_rate)

        # Define loss function
        criterion = nn.CrossEntropyLoss()
        optimizer = optim.SGD(MLP.parameters(), lr=learning_rate, momentum=0.9)

        running_loss = 0.0
        for i, data in enumerate(trainloader, 0):
            # get the inputs; data is a list of [inputs, labels]
            inputs, labels = data
            # zero the parameter gradients
            optimizer.zero_grad()
            # forward + backward + optimize
            outputs = MLP(inputs)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()
            running_loss += loss.item()

            # print statistics
            if (i+1) % 3000 == 0:    # print every 3000 mini-batches
                print('[Epoch %d, index %5d] loss: %.3f' %
                    (epoch + 1, i + 1, running_loss / 1000))
                running_loss = 0.0

    print('Finished Training \n')
    # Save trained network
    if not os.path.isdir('./trained_nets'):
        os.mkdir('./trained_nets')
    torch.save(MLP.state_dict(), PATH)
    print('Saved NN to: %s' % (os.path.abspath(PATH)))

def validate(classes, testloader, MLP, PATH):

    dataiter = iter(testloader)
    images, labels = dataiter.next()

    # Check input data
    # display_data(images, labels)

    if not os.path.isdir('./results'):
        os.mkdir('./results')
    output_path = './results/validating_'+ PATH.split('/')[-1][:-4] +'.txt'
    print('Results from inference is stored in: %s \n' % (
                os.path.abspath(output_path)))
    
    print('Start validation')
    with open(output_path, 'w', encoding='utf-8') as out: 
        correct = 0
        total = 0
        class_correct = list(0. for i in range(10))
        class_total = list(0. for i in range(10))
        with torch.no_grad():
            with profiler.profile(profile_memory=True, record_shapes=True) as prof:
                for data in testloader:
                    images, labels = data
                    # Record mem consumption and run-time
                    with profiler.record_function("model_inference"):
                        outputs = MLP(images)
                    _, predicted = torch.max(outputs, 1)
                    total += labels.size(0)
                    correct += (predicted == labels).sum().item()
                    c = (predicted == labels).squeeze()
                    for i in range(4):
                        label = labels[i]
                        class_correct[label] += c[i].item()
                        class_total[label] += 1

        # Store results
        out.write('Import network from: ' + PATH + '\n')
        # Store accuracy per class
        for i in range(10):
            print('Accuracy of %5s : %2d %%' % (
                classes[i], 100 * class_correct[i] / class_total[i]))
            out.write('Accuracy of %5s : %2d %% \n' % (
                classes[i], 100 * class_correct[i] / class_total[i]))
        # Store total accuracy
        print('Accuracy of the network on the 10 000 test images: %d %%' % (
            100 * correct / total))
        out.write('Accuracy of the network on the 10 000 test images: %d %% \n\n' % (
                    100 * correct / total))
        # Store CPU time and memory usage
        print(prof.key_averages().table(sort_by="cpu_time_total", row_limit=10))
        out.write(prof.key_averages().table(sort_by="cpu_time_total", row_limit=10))


def main():

    # Load data
    trainloader, testloader = load_data()
    # Define classes
    classes = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')

    # Loop alternating the number of neurons in the hidden layer
    # Go from 30 neurons to 300 neurons increasing 30 each step
    for i in range(30, 301, 30):
        print("Setting number of neurons to:", i)
        # Store trained nets at this location
        PATH = "./trained_nets/mnist_MLP_" + str(i) + ".pth"
        # Initialize network. 
        # Setting hidden layer size from 30 up to 300 with stepsize 30
        mlp = MPL_1_hidden(i)

        # Train network
        train(mlp, trainloader, PATH)
        
        # Validate network
        mlp.load_state_dict(torch.load(PATH))
        validate(classes, testloader, mlp, PATH)

if __name__ == "__main__":
    main()