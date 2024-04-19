#!/usr/bin/env python3

import sys
import os

'''
Sample ranks for cowpea SNPs by variable

Usage: ./sample_rank.py [snps_file] [data_files] 
'''

def find_sample(myList, val):
    for i, x in enumerate(myList):
        if val in x:
            return i


def load_data(files):  
    data = []
    with open(files[0], "r") as file:
        for line in file:
            x = line.split()
            data.append([x[0], x[1]])

    for i in range(1, len(files)):
        with open(files[i], "r") as file:
            for line in file:
                x = line.split()
                ind = find_sample(data, x[0])
                data[ind] = data[ind] + [x[1]]         
    return data


def load_snps(file):
    data = {}
    with open(file, "r") as file:
        for line in file:
            x = line.split()
            snp = (x[0], x[1], x[2])
            sample = x[3]

            if snp not in data.keys():
                data[snp] = [sample]
            else:
                smpl_list = data[snp] + [sample]
                data[snp] = smpl_list
    return data


def write_output(result):
    with open('sample_rank.txt', 'w') as file:
        for i in result:
            file.write('\t'.join(str(s) for s in i) + '\n')
    return


def rank(result, ind: int):
    rank = 1
    val = result[0][ind]
    for i in range(len(result)):
        if result[i][ind] == val:
            result[i] = result[i][:ind] + [rank] + result[i][ind+1:]
        elif result[i][ind] < val:
            rank = rank + 1
            val = result[i][ind]
            result[i] = result[i][:ind] + [rank] + result[i][ind+1:]
        else:
            print('Warning: file not sorted')
    return result


def main(snp_file, data_files):
    snps = load_snps(snp_file)
    data = []
    result = []
    data = load_data(data_files)
    cols = 4 + len(data_files)

    for snp in snps.keys():
        samples = snps[snp]
        new_list = []
        for i in data: 
            if i[0] in samples:
                new_list.append([snp[0], snp[1], snp[2]] + i)
        result = result + new_list

    for i in range(4, cols):
        result.sort(key= lambda x: x[i], reverse= True)
        result = rank(result, i)
    
    result = sorted(result, key= lambda x: tuple(x[i] for i in range(4, cols)))
    write_output(result)
    return


if len(sys.argv) < 3:
    print('Missing required input')
    exit(1)
else:
    snps_file = sys.argv[1]
    data_files = sys.argv[2:]
    main(snps_file, data_files)


if __name__ == '__main__':

    snp_file = 'sample_alt_SNP2.txt'
    data_files = ['Cowpea_Bioclim01.txt', 'Cowpea_Bioclim05.txt', 'Cowpea_Bioclim08.txt']

    main(snp_file, data_files)

  