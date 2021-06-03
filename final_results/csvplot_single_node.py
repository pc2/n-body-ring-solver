#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 13 14:39:12 2020

@author: tnellius


"""
import csv
import sys
from matplotlib import pyplot as plt
from matplotlib import rc
import numpy as np
import matplotlib.scale

#Configuration:
FONTSIZE = 12
BOLD = True

#rc('font', )   TODO: specify font
rc('text', usetex=True)

helptext="Usage:\n\r\tpython3 csvplot.py [file] [col_x_axis] [col_y_axis] [i_from] [i_to] [bool_y_limit] [plot_title](optional) [x_label](optional) [y_label](optional) [legend](optional)"
rows = []


if "help" in sys.argv:      
    print(helptext)    
    exit()

print("Called with {} arguments.".format(len(sys.argv)))

try:
    plotfile = sys.argv[1]
    col_x_axis = [int(x) for x in sys.argv[2].split(',')] #put every x column in a list
    col_y_axis = [int(y) for y in sys.argv[3].split(',')] #put ervery y column in a list
    i_from = [int(i) for i in sys.argv[4].split(',')]
    i_to = [int(i) for i in sys.argv[5].split(',')]
    
    bool_y_limit = True if int(sys.argv[6]) != 0 else False
    try:
        plot_title = str(sys.argv[7])
    except:
        plot_title = None       #no title
    try:
        x_label = str(sys.argv[8])
    except:
        x_label = None 
    try:
        y_label = str(sys.argv[9])
    except:
        y_label = None 
    try:
        legend = sys.argv[10].split(',')
    except:
        legend = None
        
    with open(plotfile, 'r', newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            rows.append(row)
except:
    print(sys.exc_info()[0])
    print("Big oof\n\r")    #you should not see this
    print(helptext)
    exit()

#prepare plot
f,ax1 = plt.subplots(figsize=(7,4.5))
plt.grid(True)
if bool_y_limit:
    y_max = max([float(y[col_y_axis[0]]) for y in rows[1:][i_from[0]:i_to[0]]])
    y_limit = np.ceil((y_max + (0.1*y_max))/1000)*1000
    plt.ylim(0, y_limit)

#get labels
if(x_label == None or x_label == ""):
    x_label = rows[0][col_x_axis[0]]
if(y_label == None or y_label == ""):
    y_label = rows[0][col_y_axis[0]]


#actual plotting:
i = 0
#plt.xticks(np.arange(1,16,step=2))
#plt.yticks(np.arange(1,16,step=2))

print(i_from, i_to)
print(rows[1:][i_from[0]:i_to[0]])


ax2 = ax1.twinx()
for x_col,y_col, ifrom, ito in zip(col_x_axis, col_y_axis, i_from, i_to):
    
    #get columns of csv file without first row
    x_axis_list = list(map(lambda x: int(x[x_col]), rows[1:][ifrom:ito]))
    y_axis_list = list(map(lambda y: float(y[y_col]), rows[1:][ifrom:ito]))

    print(x_axis_list)
    print(y_axis_list)
    markers = '-o'
    fill_style='full'
    if i == 0:
        markers = 'C0-s'
    elif i == 1:
        markers = 'C1-s'
    elif i == 2:
        markers = 'C0--^'
        fill_style='none'
    else:
        markers = 'C1--^'
        fill_style='none'
    #plt.xticks(np.arange(0,4097,step=1024))
    if i == 0:
        #plt.xticks(rotation=45)
        ax1.set_xscale('log', basex=2)
        ticks = np.exp2(np.arange(7,20))
        ax1.set_xticks(ticks)
        ax1.get_xaxis().set_major_formatter(matplotlib.ticker.ScalarFormatter())
        ax2.set_xscale('log', basex=2)
        ax2.set_xticks(ticks)
        ax2.get_xaxis().set_major_formatter(matplotlib.ticker.ScalarFormatter())
        #ax1.set_xticklabels(x_axis_list)
    if i < 2:
        ax1.plot(x_axis_list, y_axis_list,markers,markevery=1,label=legend[i])
    #else:
    #    ax1.plot(x_axis_list, y_axis_list,'.--',color='orange',markevery=1,label=legend[i])
    else:
        ax2.plot(x_axis_list, y_axis_list,markers,fillstyle='none',label=legend[i])

    i += 1

#ax1.set_xscale('log', basex=2)

x_huthmann = [1024, 32768, 524288]
y_huthmann = [250, 7700, 11800]
ax1.scatter(x_huthmann, y_huthmann, c='k', marker='x', label='Huthmann Performance')

for tick in ax1.get_xticklabels():
    tick.set_rotation(45)
for tick in ax2.get_xticklabels():
    tick.set_rotation(45)

#ax1.set_yscale('log')
print("Done plotting")
print(plot_title)
print(x_label)
print(y_label)
#print titles
if(BOLD):
    if(plot_title != None and plot_title != ""):
        ax1.set_title(r'\textbf{{{0}}}'.format(plot_title), fontsize=FONTSIZE)
    ax1.set_xlabel(r'\textbf{{{0}}}'.format(x_label), fontsize=FONTSIZE)
    ax1.set_ylabel(r'\textbf{{{0}}}'.format(y_label), fontsize=FONTSIZE)
    ax2.set_ylabel(r'\textbf{MPairs/s/W}', fontsize=FONTSIZE, rotation=270, labelpad=15)
else:
    if(plot_title != None and plot_title != ""):
        plt.title(r'{0}'.format(plot_title), fontsize=FONTSIZE)
    plt.xlabel(r'{0}'.format(x_label), fontsize=FONTSIZE)
    plt.ylabel(r'{0}'.format(y_label), fontsize=FONTSIZE)

if legend:
    lines_1, labels_1 = ax1.get_legend_handles_labels()
    lines_2, labels_2 = ax2.get_legend_handles_labels()
    lines = lines_1[0:2] + lines_2 + lines_1[2:3]
    labels = labels_1[0:2] + labels_2 + labels_1[2:3]
    ax1.legend(lines,labels, loc=5, fontsize='small', bbox_to_anchor=(1.0,0.55))

filename = "_".join([(plotfile[:-4] if plot_title==None else plot_title), str(min(i_from)), str(max(i_to))])

f.tight_layout()
f.savefig(filename + ".pdf", bbox_inches='tight')     #save as pdf

