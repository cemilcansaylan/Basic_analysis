#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import matplotlib.pyplot as plt
import os
import pandas as pd
from statistics import mean 


# In[60]:


SIM_NAME = '2v2a3e'


# In[52]:


PATH = '/run/user/1000/gvfs/sftp:host=160.75.91.59,user=badaylab/Volumes/My_Book_Duo/work/projects/peptides_amphihiles/stupp_jacs2010'


# In[53]:


sim1name = SIM_NAME + "-min100"
sim2name = SIM_NAME + "-min200"
sim3name = SIM_NAME + "-min500"


# In[54]:


def Hbond_align(SIM_NAME,MIN_NAME):
    hbond_align = pd.DataFrame()
    
    for i in range(121,182):
        df = pd.read_csv(PATH+f"/pal-{SIM_NAME}/analysis/{MIN_NAME}-analysis/hbond_align/pal-{SIM_NAME}_hbond_align_{i}_{i-1}.dat", 
                         delimiter='\t', 
                         index_col='#Frame')
    
        hbond_align[str(i)] = df["HB_00001[UU]"]
    
    mean_hbond =hbond_align.mean(axis=0).to_list()
    degree = hbond_align.columns.to_list()
    
    return degree, mean_hbond
    


# In[55]:


degree, min100_mean_hbond = Hbond_align(SIM_NAME, "min100")
degree, min200_mean_hbond = Hbond_align(SIM_NAME, "min200")
degree, min500_mean_hbond = Hbond_align(SIM_NAME, "min500")


# In[59]:


fig, ax1=plt.subplots(figsize=(15,8))


plt.plot(degree, min100_mean_hbond, label=str(sim1name))
plt.plot(degree, min200_mean_hbond, label=str(sim2name))
plt.plot(degree, min500_mean_hbond, label=str(sim3name))


lgd=ax1.legend([ str(sim1name),str(sim2name),str(sim3name) ])

#for label in lgd.get_lines():
#    label.set_linewidth(6)  # the legend line width
#for label in  lgd.get_texts():
#    label.set_fontsize('10')


#plt.legend(loc='upper right', bbox_to_anchor=(1.4, 0.5))
plt.xlabel("Hbond Degree")
plt.ylabel("# of Hbond")
plt.xticks(rotation=90)

plt.grid(True)

fig.savefig(f'{SIM_NAME}-Hbond_alignment.png', dpi=300, 
            format='png',
            bbox_extra_artists=(lgd,), 
            bbox_inches='tight')

