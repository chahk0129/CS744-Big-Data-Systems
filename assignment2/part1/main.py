import argparse
import os
import torch
import json
import copy
import numpy as np
from torchvision import datasets, transforms
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
import logging
import random
import model as mdl
import time
device = "cpu"
torch.set_num_threads(4)
batch_size = 256 # batch for one node
log_iter = 20

def train_model(model, train_loader, optimizer, criterion, epoch, stop_iter):
    """
    model (torch.nn.module): The model created to train
    train_loader (pytorch data loader): Training data loader
    optimizer (optimizer.*): A instance of some sort of optimizer, usually SGD
    criterion (nn.CrossEntropyLoss) : Loss function used to train the network
    epoch (int): Current epoch number
    stop_iter (int): Stop iteration at the predetermined iteration
    """
    start_time = time.time()
    log_iter_start_time = time.time()
    with open(f'output/{log_file_name}', 'a+') as f:
        for batch_idx, (data, target) in enumerate(train_loader):
            if batch_idx >= stop_iter:
                break
            batch_count = batch_idx + 1
            # Reference: https://github.com/pytorch/examples/blob/master/mnist/main.py
            data, target = data.to(device), target.to(device)
            optimizer.zero_grad()
            output = model(data)
            loss = criterion(output, target)
            loss.backward()
            optimizer.step()

            elapsed_time = time.time() - start_time

            f.write(f"{epoch},{batch_count},{elapsed_time}\n")

            start_time = time.time()
            if batch_count % log_iter == 0:
                log_iter_elapsed_time = time.time() - log_iter_start_time
                print('Train Epoch: {} \t Iteration: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}\t elapsed time: {:.3f}'.format(
                    epoch, batch_count, batch_count * len(data), len(train_loader.dataset),
                    100. * batch_count / len(train_loader), loss.item(), log_iter_elapsed_time)) 
                log_iter_start_time = time.time()
    return None

def test_model(model, test_loader, criterion):
    model.eval()
    test_loss = 0
    correct = 0
    with torch.no_grad():
        for batch_idx, (data, target) in enumerate(test_loader):
            data, target = data.to(device), target.to(device)
            output = model(data)
            test_loss += criterion(output, target)
            pred = output.max(1, keepdim=True)[1]
            correct += pred.eq(target.view_as(pred)).sum().item()

    test_loss /= len(test_loader)
    print('Test set: Average loss: {:.4f}, Accuracy: {}/{} ({:.0f}%)\n'.format(
            test_loss, correct, len(test_loader.dataset),
            100. * correct / len(test_loader.dataset)))
            

def main():
    
    parser = argparse.ArgumentParser()
    parser.add_argument('--master-ip', type=str, default='10.10.1.1', help='master node ip (default: 10.10.1.1)')
    parser.add_argument('--num-nodes', type=int, default=1, help='the number of nodes (default:1)')
    parser.add_argument('--rank', type=int, default=0, help='rank of node')
    parser.add_argument('--epoch', type=int, default=1, help='the number of epochs (default:1)')
    parser.add_argument('--stop_iter', type=int, default=40, help='Stop iteration at, (default: 40)')

    args = parser.parse_args()
    num_epochs = args.epoch
    stop_iter = args.stop_iter
    global log_file_name
    log_file_name = f"timelog_{num_epochs}_{stop_iter}.csv"
    with open(f'output/{log_file_name}', 'w+') as f:
        f.write("epoch,iteration,elpased_time\n")

    normalize = transforms.Normalize(mean=[x/255.0 for x in [125.3, 123.0, 113.9]],
                                std=[x/255.0 for x in [63.0, 62.1, 66.7]])
    transform_train = transforms.Compose([
            transforms.RandomCrop(32, padding=4),
            transforms.RandomHorizontalFlip(),
            transforms.ToTensor(),
            normalize,
            ])

    transform_test = transforms.Compose([
            transforms.ToTensor(),
            normalize])
    training_set = datasets.CIFAR10(root="./data", train=True,
                                                download=True, transform=transform_train)
    train_loader = torch.utils.data.DataLoader(training_set,
                                                    num_workers=2,
                                                    batch_size=batch_size,
                                                    sampler=None,
                                                    shuffle=True,
                                                    pin_memory=True)
    test_set = datasets.CIFAR10(root="./data", train=False,
                                download=True, transform=transform_test)

    test_loader = torch.utils.data.DataLoader(test_set,
                                              num_workers=2,
                                              batch_size=batch_size,
                                              shuffle=False,
                                              pin_memory=True)
    training_criterion = torch.nn.CrossEntropyLoss().to(device)

    model = mdl.VGG11()
    model.to(device)
    optimizer = optim.SGD(model.parameters(), lr=0.1,
                          momentum=0.9, weight_decay=0.0001)
    for epoch in range(num_epochs):
        train_model(model, train_loader, optimizer, training_criterion, epoch, stop_iter)
    test_model(model, test_loader, training_criterion)

if __name__ == "__main__": 
    main()
