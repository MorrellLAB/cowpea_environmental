#!/usr/bin/env python3
# Elaine Lee
# Input is a list of SNPs and the samples that carry the alternate allele.
# The format is: Chromosome Position SNP_ID Sample_ID
# Example: Vu01 12345 SNP1 TVu-10311
# Secondary input is a list of all samples and the Bioclim value pre-sorted.
# We are intested in extremes, so highest temperatures have highest rank.
# Lowest rainfall would have highest rank.
# The format is: Sample_ID Bioclim_value
# The first two rows of samples for a value might  be: TVu-10311	30.53333282; TVu-14402	29.91666794
# The user can provide an arbitrary number of Bioclim lists, but Bioclim 01, 05, and 08 are good 
# for temperature.


import sys
import os
from scipy.stats import friedmanchisquare

'''
Sample ranks for cowpea SNPs by variable

Usage: ./sample_rank.py [snps_file] [Bioclim_data_files]
       [Optional: variable_classes file with format: var_index class_name]
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


def compute_snp_stats(snp_results, num_vars):
    """
    Compute statistics for a single SNP across all variables.
    Returns mean ranks, Friedman test results, and Kendall's W.
    """
    if not snp_results:
        return None
    
    # Extract ranks for each variable (columns 4 onwards)
    var_ranks = [[] for _ in range(num_vars)]
    for row in snp_results:
        for var_idx in range(num_vars):
            var_ranks[var_idx].append(float(row[4 + var_idx]))
    
    # Calculate mean ranks for each variable
    mean_ranks = [sum(ranks) / len(ranks) for ranks in var_ranks]
    
    # Perform Friedman test if enough samples
    if len(snp_results) > 2:
        stat, pval = friedmanchisquare(*var_ranks)
        # Calculate Kendall's W (effect size)
        # W = 12*S / (k^2 * (n^3 - n))
        # where S is sum of squared rank deviations
        n = len(snp_results)
        k = num_vars
        mean_rank = sum(mean_ranks) / k
        s = sum((r - mean_rank) ** 2 for r in mean_ranks) * n
        w = (12 * s) / (k ** 2 * (n ** 3 - n))
    else:
        stat, pval, w = None, None, None
    
    return {
        'mean_ranks': mean_ranks,
        'stat': stat,
        'pval': pval,
        'kendall_w': w,
        'num_samples': len(snp_results)
    }


def load_variable_classes(classes_file):
    """
    Load variable classifications from file.
    Format: var_index (0-based) variable_class_name
    Example: 0 Temperature
             1 Temperature
             2 Temperature
             3 Precipitation
    """
    classes = {}
    with open(classes_file, 'r') as f:
        for line in f:
            parts = line.strip().split()
            if len(parts) >= 2:
                var_idx = int(parts[0])
                class_name = parts[1]
                classes[var_idx] = class_name
    return classes


def compute_class_stats(snp_results, var_classes, num_vars):
    """
    Compute statistics by variable class.
    """
    if not var_classes or not snp_results:
        return None

    # Group variables by class
    class_ranks = {}
    for var_idx in range(num_vars):
        if var_idx in var_classes:
            class_name = var_classes[var_idx]
            if class_name not in class_ranks:
                class_ranks[class_name] = []

            for row in snp_results:
                class_ranks[class_name].append(
                    float(row[4 + var_idx]))

    # Calculate mean rank by class
    class_means = {}
    for class_name, ranks in class_ranks.items():
        class_means[class_name] = sum(ranks) / len(ranks)

    return class_means

def write_stats_output(stats_by_snp, num_vars, var_classes=None,
                       class_stats_by_snp=None):
    """Write statistical summary to file."""
    with open('snp_stats.txt', 'w') as file:
        file.write('SNP\tNum_Samples\t')
        file.write('\t'.join([f'Mean_Rank_Var{i+1}' for i in
                              range(num_vars)]))
        
        # Add class columns if available
        if var_classes:
            unique_classes = sorted(set(var_classes.values()))
            file.write('\t' +
                       '\t'.join([f'Mean_Rank_{c}' for c in
                                  unique_classes]))
        
        file.write('\tFriedman_Stat\tP_Value\tKendall_W\t'
                   'Effect_Size\tLowest_Rank_Var')
        
        if var_classes:
            file.write('\tLowest_Rank_Class')
        
        file.write('\n')
        
        for snp_id, stats in stats_by_snp.items():
            if stats is None:
                continue
            
            mean_ranks = stats['mean_ranks']
            lowest_var = mean_ranks.index(min(mean_ranks)) + 1
            stat_str = (f"{stats['stat']:.4f}" if stats['stat']
                        else "NA")
            pval_str = (f"{stats['pval']:.6f}" if stats['pval']
                        else "NA")
            w_str = (f"{stats['kendall_w']:.4f}" if
                     stats['kendall_w'] is not None else "NA")
            
            # Interpret effect size
            if stats['kendall_w'] is None:
                effect = "NA"
            elif stats['kendall_w'] < 0.1:
                effect = "negligible"
            elif stats['kendall_w'] < 0.3:
                effect = "small"
            elif stats['kendall_w'] < 0.5:
                effect = "medium"
            else:
                effect = "large"
            
            file.write(f"{snp_id}\t{stats['num_samples']}\t")
            file.write('\t'.join([f"{r:.2f}" for r in mean_ranks]))
            
            # Write class means if available
            if var_classes and snp_id in class_stats_by_snp:
                class_means = class_stats_by_snp[snp_id]
                unique_classes = sorted(set(var_classes.values()))
                file.write('\t' +
                           '\t'.join([f"{class_means.get(c, 0):.2f}"
                                      for c in unique_classes]))
            
            file.write(f"\t{stat_str}\t{pval_str}\t{w_str}\t"
                       f"{effect}\t{lowest_var}")
            
            # Write lowest class if available
            if var_classes and snp_id in class_stats_by_snp:
                class_means = class_stats_by_snp[snp_id]
                lowest_class = min(class_means,
                                   key=class_means.get)
                file.write(f"\t{lowest_class}")
            
            file.write('\n')



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


def main(snp_file, data_files, classes_file=None):
    snps = load_snps(snp_file)
    data = []
    result = []
    data = load_data(data_files)
    cols = 4 + len(data_files)
    num_vars = len(data_files)

    for snp in snps.keys():
        samples = snps[snp]
        new_list = []
        for i in data:
            if i[0] in samples:
                new_list.append([snp[0], snp[1], snp[2]] + i)
        result = result + new_list

    for i in range(4, cols):
        result.sort(key=lambda x: x[i], reverse=True)
        result = rank(result, i)

    result.sort(key=lambda x: (x[2], tuple(x[i] for i in
                                           range(4, cols))))
    write_output(result)

    # Load variable classes if provided
    var_classes = None
    if classes_file:
        var_classes = load_variable_classes(classes_file)

    # Compute statistics by SNP
    stats_by_snp = {}
    class_stats_by_snp = {}
    current_snp = None
    current_snp_data = []

    for row in result:
        snp_id = row[2]
        if snp_id != current_snp:
            if current_snp is not None:
                stats = compute_snp_stats(current_snp_data,
                                          num_vars)
                stats_by_snp[current_snp] = stats
                if var_classes:
                    class_stats = compute_class_stats(
                        current_snp_data, var_classes,
                        num_vars)
                    class_stats_by_snp[current_snp] = (
                        class_stats)
            current_snp = snp_id
            current_snp_data = [row]
        else:
            current_snp_data.append(row)

    # Don't forget last SNP
    if current_snp is not None:
        stats = compute_snp_stats(current_snp_data, num_vars)
        stats_by_snp[current_snp] = stats
        if var_classes:
            class_stats = compute_class_stats(current_snp_data,
                                              var_classes,
                                              num_vars)
            class_stats_by_snp[current_snp] = class_stats

    write_stats_output(stats_by_snp, num_vars, var_classes,
                       class_stats_by_snp)
    return


if len(sys.argv) < 3:
    print('Missing required input')
    print('Usage: sample_rank.py [snps_file] [bioclim_files...]'
          ' [optional: --classes class_file]')
    exit(1)
else:
    snps_file = sys.argv[1]
    classes_file = None
    
    # Check for --classes flag
    if '--classes' in sys.argv:
        idx = sys.argv.index('--classes')
        data_files = sys.argv[2:idx]
        classes_file = sys.argv[idx + 1]
    else:
        data_files = sys.argv[2:]
    
    main(snps_file, data_files, classes_file)

'''
#tests
if __name__ == '__main__':

    snp_file = 'sample_alt_SNP2.txt'
    data_files = ['Cowpea_Bioclim01.txt', 'Cowpea_Bioclim05.txt', 'Cowpea_Bioclim08.txt']

    main(snp_file, data_files)

'''
