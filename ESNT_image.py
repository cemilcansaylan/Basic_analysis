#!/usr/bin/env python
# coding: utf-8

import requests
from bs4 import BeautifulSoup

#Set URL of transcript image only for Homo_sapiens
URL = "https://www.ensembl.org/Homo_sapiens/Component/Transcript/Summary/image?db=core;t="
#List 
ENST_list = ["ENST00000380152", "ENST00000680887", "ENST00000544455", "ENST00000530893"]


for ENST in ENST_list:
    #Get image src URL
    soup = BeautifulSoup(requests.get(URL+ENST).content, "html.parser")
    imgURL = soup.find("img").attrs.get("src")
    
    #Write image
    response = requests.get(f"https:{imgURL}")
    file = open(f"{ENST}.png", "wb")
    file.write(response.content)
    file.close()