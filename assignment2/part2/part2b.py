import argparse
import os
import torch
import json
import copy
import numpy as np
import pandas as pd
from torchvision import datasets, transforms
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
import logging
import random
import model as mdl
import time
import torch.distributed as dist
from torch.utils.data.distributed import DistributedSampler
device = "cpu"
torch.set_num_threads(4)
batch_size = 64 # batch for one node
log_iter = 20
group_list = [0, 1, 2, 3]

def train_model(model, train_loader, optimizer, criterion, epoch, rank):
    """
    model (torch.nn.module): The model created to train
    train_loader (pytorch data loader): Training data loader
    optimizer (optimizer.*): A instance of some sort of optimizer, usually SGD
    criterion (nn.CrossEntropyLoss) : Loss function used to train the network
    epoch (int): Current epoch number
    """

    # declare groups 
    group = dist.new_group(group_list)
    
    # remember to exit the train loop at end of the epoch
    start_time = time.time()
    for batch_idx, (data, target) in enumerate(train_loader):
        # Reference: https://github.com/pytorch/examples/blob/master/mnist/main.py
        data, target = data.to(device), target.to(device)
        optimizer.zero_grad()
        output = model(data)
        loss = criterion(output, target)
        loss.backward()

        group_size = len(group_list)

        # Communicating gradients
        for params in model.parameters():
            params.grad = params.grad / group_size
            dist.all_reduce(params.grad, op=dist.reduce_op.SUM, group=group, async_op=False)
        
        optimizer.step()
        if (batch_idx % log_iter == 0):
            elapsed_time = time.time() - start_time
            print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}\t elapsed time: {:.3f}'.format(
                epoch, batch_idx * len(data) * group_size, len(train_loader.dataset),
                100. * batch_idx / len(train_loader), loss.item(), elapsed_time))
            start_time = time.time()
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
            

def init_process(master_ip, rank, size, fn, backend='gloo'):
    """ Initialize the distributed environment. """
    os.environ['MASTER_ADDR'] = master_ip
    os.environ['MASTER_PORT'] = '29500'
    dist.init_process_group(backend, rank=rank, world_size=size)
    fn(rank, size)



def run(rank, size):
    torch.manual_seed(2021)
    np.random.seed(2021)
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
    sampler = DistributedSampler(training_set) if torch.distributed.is_available() else None
    train_loader = torch.utils.data.DataLoader(training_set,
                                                    num_workers=2,
                                                    batch_size=batch_size,
                                                    sampler=sampler,
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
    # running training for one epoch
    df = pd.DataFrame()
    for epoch in range(1):
        start_time = time.time()
        train_model(model, train_loader, optimizer,
                training_criterion, epoch, rank)
        test_model(model, test_loader, training_criterion)
        elapsed_time = time.time() - start_time
        df = df.append({
            'epoch': epoch,
            'elapsed_time': elapsed_time
        }, ignore_index=True)
    df.to_csv(args.output_path)


if __name__ == "__main__":  
    parser = argparse.ArgumentParser()
    parser.add_argument('--master-ip', type=str, default='10.10.1.1', help='master node ip (default: 10.10.1.1)')
    parser.add_argument('--num-nodes', type=int, default=4, help='the number of nodes (default:4)')
    parser.add_argument('--rank', type=int, default=0, help='rank of node')
    parser.add_argument('--epoch', type=int, default=1, help='the number of epochs (default:1)')
    parser.add_argument('--exp_iter', type=int, default=10, help='the number of one epoch training (default:10)')
    parser.add_argument('--output_path', type=str, default='elapsed_time_part2b.csv', help='output (elapsed time) path')
    args = parser.parse_args()
    init_process(args.master_ip, args.rank, args.num_nodes, run)


