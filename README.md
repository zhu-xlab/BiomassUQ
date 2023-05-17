# BiomassUQ

Data used in the [paper](https://arxiv.org/pdf/2305.09555.pdf) "Biomass Estimation and Uncertainty Quantification from Tree Height". 

# Getting Started
1. install R
2. install required packages:
   - ggplot2
   - magrittr
   - plyr
   - dplyr
   - readxl
   - BAAD (https://github.com/dfalster/baad)

# Download the data
1. Download the Chave data at http://chave.ups-tlse.fr/pantropical_allometry/Chave_GCB_Direct_Harvest_Data.csv, and rename the file as "chave.csv";
2. Download the biomass data at https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Felar.usfeu.ru%2Fbitstream%2F123456789%2F4931%2F2%2FBDengl2-1.xlsx&wdOrigin=BROWSELINK, 
and rename the file as "EURASIAN_FORESTS.xlsx".

# Data preparation
Run ``pre_data.R``

# References

[1] J. Chave, M. R´ejou-M´echain, A. B´urquez, E. Chidumayo, M. S. Colgan,
W. B. Delitti, A. Duque, T. Eid, P. M. Fearnside, R. C. Goodman, et al.,
“Improved allometric models to estimate the aboveground biomass of
tropical trees,” Global change biology, vol. 20, no. 10, pp. 3177–3190,
2014.

[2] D. S. Falster, R. A. Duursma, M. I. Ishihara, D. R. Barneche, R. G.
FitzJohn, A. V˚arhammar, M. Aiba, M. Ando, N. Anten, M. J. Aspinwall,
et al., “Baad: A biomass and allometry database for woody plants.,” tech.
rep., Ecological Society of America, 2015.

[3] Usoltsev, V.A. Sample tree biomass data for Eurasian forests : 
CD-version = Фитомасса деревьев в лесах Евразии : электронная база данных / 
V. A. Usoltsev ; Ministry of education and science of Russian Federation, 
Ural State Forest Engineering University, Institute of economics and management. 
– Yekaterinburg, 2015. – Издание представлено на англ. и рус. языке.

[4] Q. Song, et al., "Biomass Estimation and Uncertainty Quantification 
from Tree Height", IEEE JSTARS, 2023. (Accepted)
