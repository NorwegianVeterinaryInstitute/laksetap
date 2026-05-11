# Background
This document contains precise mathematical formulas for the calculations conducted in the app "Laksetap". They show how monthly mortality risks, yearly cumulative mortality risk and cumulative production cycle mortality risks are calculated. Procedures for data cleaning/ data control is not part of this document. 

# Data
The following data is used as input for the different calculations:

- ***site\_nr*** (Character). ID for farm/ site. Given with five digits (numbers) ranging from "10029" till "45266".
- ***species*** (Character). The two species of interest/ that are used is "Laks" and "Regnbueørret".
- ***date*** (Date, YYYY-MM-DD). The resolution is monthly.
- ***at_risk*** (Double/numeric). The number of fish "at risk" in a farm. Let $N_{it}$ be the number of fish present at the start of the month for farm $i$ in month $t$. Furthermore, let $\overline{N_{it}}=\frac{N_{it}+N_{i(t+1)}}{2}$ denote the number of fish "***at_risk***". This is the average number of the number registered at the start of the month and the end of the month (= start point next month). *NB!* It is not necessarily so that $N_{i(t+1)} = N_{it}-M_{it}$, where $M_{it}$ is the number of dead fish (see below), as fish might vanish from farms for other reasons (for instance escaped) than the ones registered as ***dead***.
- ***dead*** (integer). The number of registered dead fish per site and month. Let $M_{it}$ denote the number of dead fish in farm $i$, month $t$.
- ***area*** (Character): Management area. The variable has 13 levels, "1", "2",...,
"13" representing the 13 management areas. 
- ***county*** (Character): County. The variable has 15 levels, "Østfold",...,"Finnmark".
- ***months_at_sea*** (Integer) The number of months that the production cycle has been in the sea. The first month is given "1", etc. The month of slaughtering is coded with "0".

# Formulas
## Mortality rate
The mortality rate, $\Delta M_{it}$, for ***site\_nr*** $i$ in month $t$, is defined as the proportion of total number of dead fish to the number of fish at risk, i.e.:

$$\Delta M_{it} = \frac{M_{it}}{\overline{N_{it}}}\hspace{10mm} (1)$$

## Mortality risk
Furthermore, the mortality risk, $R_{it}$, for ***site\_nr*** $i$ in month $t$, is defined as: 

$$R_{it}  = 1- e^{-\Delta M_{it}}\hspace{10mm} (2)$$

The mortality rate and mortality risk are closely connected and the mortality risk is a strictly increasing function of the mortality rate. For small numbers mortality rate and mortality risks are almost the same, but as the mortality rate increases, the gap between mortality rate and risk increases. 


The mortality rate and mortality risk are connected and the mortality risk is a strictly increasing function of the mortality rate. For small numbers mortality rate and mortality risks are almost the same, but as the mortality rate increases, the gap between mortality rate and risk increases, see figure below. 


![Mortality risk as function of mortality rate with black line, the red line show the 1:1 relationship](rate_vs_risk.png)

## Cumulative mortality risk
An important point is that the total (cumulative) risk over several months, from month $t$ till month $t+n$, denoted $R^{tot}_{i,t,t+n}$, (for ***site\_nr*** $i$) might be calculated as (see Bang Jensen, Qviller \& Toft, 2020):

$$R^{tot}_{i,t,t+n} = 1 - \prod_{k = t}^{t+n}(1-R_{ik}) = 1-e^{-\sum_{k = t}^{t+n}\Delta M_{ik}}\hspace{10mm} (3)$$
, which is a somewhat cumbersome way of writing that the survival probabilities (1 - risk) might be multiplied. 


# Monthly mortality
Let $\mathit{S}$ denote a subset of the farms, representing a geographical aggregation level. The level might be county or combinations of counties, management area or combinations of management areas or national. Then, for subset $\mathit{S}$ the following numbers are calculated:

- $n_{\mathit{S}_t}$: The number of active farms, i.e. registrations of dead fish and fish ***at risk*** for the month $t$ in question. 
- $M_{it}$ and $R_{it}$ are calculated for all farms in subset $\mathit{S}$, i.e. $i = 1,..,n_{\mathit{S}_t}$ based on equations 1 and 2. Only results based on mortality risks (i.e. $R_{it}$) are reported in Laksetap. 
- $\xi^{25}_{R_{\mathit{S}_t}}$, $\xi^{50}_{R_{\mathit{S}_t}}$ and $\xi^{75}_{R_{\mathit{S}_t}}$, i.e. 25%, 50% (median) and 75% percentiles for mortality risk within the subset ($\mathit{S}$) in question are calculated and reported in Laksetap.  
- ***Note***: The percentiles  $\xi^{25}_{R_{\mathit{S}_t}}$ and $\xi^{75}_{R_{\mathit{S}_t}}$ is a representation the variation in mortality between farms. These percentiles are not systematically affected by the number of farms ($n_{\mathit{S}_t}$).


# Production cycle cumulative mortality
## Valid production cycles 
The first step is to identify valid production cycles. The following criteria is used:  

- The production cycle has to be registered as slaughtered (the last month has registration "0" for variable ***months\_at\_sea***).  
- The production cycle has to have valid registrations for ***at\_risk*** and ***dead*** for all months in the cycle (no missing data allowed).  
- The production cycle has to have been at sea for a minimum of 8 months and maximum of 24 months.


## Subsets of production cycles
Let $\mathit{S}_y$ denote a subset of valid production cycles (see above) that are slaughtered within a given year ($y$) and a defined geographical aggregation level (MA, county or the whole country). Then, for each subset defined in the input the following numbers are calculated:

- $n_{\mathit{S}_y}$: The total number of production cycles ending in year $y$. 
- The cumulative total mortality risk for each production cycle, $R^{tot}_{i,t_{i1},t_{i1}+n_i-1}$, by equation (3). Here $t_{i1}$ is the first month at sea for production cycle $i$ and $n_i$ is the total months the production cycle is in the sea. Note that the start months, $t_{i1}$'s, and the number of months at sea, $n_j$'s, might vary between the different production cycles. The end month, i.e. $t_{i1}+n_i-1$ has to fall within year $y$.   
- In Laksetap $\xi^{25}_{R^{tot}_{\mathit{S}_y}}$, $\xi^{50}_{R^{tot}_{\mathit{S}_y}}$ and $\xi^{75}_{R^{tot}_{\mathit{S}_y}}$, i.e. 25%, 50% (median) and 75% percentiles for cumulative total mortality risk within the subset ($\mathit{S}_y$) in question are reported. i.e. the  25%, 50% (median) and 75% percentiles is only reported at a yearly time level crossed the different geographical aggregation levels. 

# Yearly cumulative mortality
## Subset of farms
Let $\mathit{S}_y$ denote the subset of farms within a geographical aggregation level that has valid registrations for at least one month within year $y$. The yearly cumulative mortality is calculated and reported as follows: 

- ***Step 1***: Calculate monthly mortality rates $\Delta M_{it}$ for all farms in $\mathit{S}_y$ in and months with data according to Eq. (1).
- ***Step 2***: Let $n_{\mathit{S}_{yt}}$ be the number of farms with valid data in $\mathit{S}_y$ in month $t\in y$. The mean mortality rate in month $t$ is calculated as:

$$\overline{\Delta M_{\mathit{S}_{yt}}} = \frac{1}{n_{\mathit{S}_{yt}}}\sum_{i \in \mathit{S}_{yt}}\Delta M_{it}\hspace{10mm} (4)$$ 

- ***Step 3***: Calculate the mean yearly cumulative mortality in month $t = 1,\ldots,12$ risks as: 

$$R^{tot}_{\mathit{S},t} = 1-e^{-\sum_{k = 1}^{t}\overline{\Delta M_{\mathit{S}_{yt}}}}\hspace{10mm} (5)$$

- ***Step 4***: The mean yearly cumulative mortality risks for all months, January till December, for the different spatial aggregation levels, are shown and reported in the Laksetap app. 


# References
Bang Jensen, B., Qviller, L., og Toft, N. (2020). Spatio-temporal variations in mortality during the seawater production phase of Atlantic salmon (Salmo salar) in Norway. Journal of Fish Diseases, 43, 445–457.




