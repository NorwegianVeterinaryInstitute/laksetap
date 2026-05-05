####  Background
This document contains precise mathematical formulas for the calculations conducted in the app "Laksetap". They show how monthly mortality risks, yearly cumulative mortality risk and cumulative production cycle mortality risks are calculated. Procedures for data cleaning/ data control is not part of this document. 

####  Monthly mortality
The monthly moralities are based on the function ***summarize\_monthly\_mortality***. 

The function takes the following variables as input:

- ***site\_nr*** (Character). ID for farm/ site.
- ***species*** (Character). The two species of interest/ that are used is "Laks" and "Regnbueørret".
- ***date*** (Date). The resolution is monthly.
- ***at_risk*** (Double/numeric). The number of fish "at risk" in a farm. Let $N_{it}$ be the number of fish present at the start of the month for farm $i$ in month $t$. Furthermore, let $$\overline{N_{it}}=\frac{N_{it}+N_{i(t+1)}}{2}$$ denote the number of fish "***at_risk***". This is the average number of the number registered at the start of the month and the end of the month (= start point next month). *NB!* It is not necessarily so that $$N_{i(t+1)} = N_{it}-M_{it}$$, where $M_{it}$ is the number of dead fish (see below), as fish might vanish from farms for other reasons (for instance escaped) than the ones registered as ***dead***.
- ***dead*** The number of registered dead fish per site and month. Let $M_{it}$ denote the number of dead fish in farm $i$, month $t$.
- ***area*** (Character): Management area.
- ***county*** (Character): County.


The first step is to calculate mortality rates for all farm and months in question. The geographical aggregation level might be county, management area or national. The mortality rate, $\Delta M_{it}$, is defined as the proportion of total number of dead fish to the number of fish at risk, i.e.:

$$\Delta M_{it} = \frac{M_{it}}{\overline{N_{it}}}\hspace{10mm} (1)$$
Furthermore, the mortality risk, $R_{it}$ is defined as 

$$R_{it}  = 1- e^{-\Delta M_{it}}\hspace{10mm} (2)$$

The mortality rate and mortality risk are connected and the mortality risk is a strictly increasing function of the mortality rate. For small numbers mortality rate and mortality risks are almost the same, but as the mortality rate increases, the gap between mortality rate and risk increases, see figure below. 


![an image](vetinst-logo-no.png)

An important point is that the total risk over several months, from month $t$ till month $t+n$, denoted $R^{tot}_{i,t,t+n}$, might be calculated as (see Bang Jensen, Qviller \& Toft, 2020):

$$R^{tot}_{i,t,t+n} = 1 - \prod_{k = t}^{t+n}(1-R_{ik}) = 1-e^{-\sum_{k = t}^{t+n}\Delta M_{ik}}\hspace{10mm} (3)$$
, which is a somewhat cumbersome way of writing that the survival probabilities (1 - risk) might be multiplied. 

Let $\mathit{S}$ denote a subset of the farms, i.e. $\mathit{S}$ might be all the farms within a MA (management area) or county (Fylke) or the whole country (Norway). Then, for each subset defined in the input the following numbers are calculated:

- $n_{\mathit{S}t}$: The number of active farms, i.e. registrations of dead fish and fish ***at risk*** for the month $t$ in question. 
- $\xi^{25}_{R_{\mathit{S}t}}$, $\xi^{50}_{R_{\mathit{S}t}}$ and $\xi^{75}_{R_{\mathit{S}t}}$, i.e. 25%, 50% (median) and 75% percentiles for mortality risk within the subset ($\mathit{S}$) in question. 
- The mean mortality risk ($\overline{R_{\mathit{S}t}}$) for subset $\mathit{S}$, month $t$ calculated as $\overline{R_{\mathit{S}t}} = \frac{1}{n_{\mathit{S}t}}\sum_{i\in \mathit{S}}R_{it}$.
- Approximate lower and upper limits for a 95% Confidence interval for the ***TRUE*** average risk in subset $\mathit{S}$ in month $t$ given as $\overline{R_{\mathit{S}t}} \pm 1.96\underset{\text{standard error}}{\underbrace{\sqrt{\frac{\sum_{i\in \mathit{S}}\left(R_{it}-\overline{R_{\mathit{S}t}}\right)^2}{n_{\mathit{S}t}(n_{\mathit{S}t}-1)}}}}$. 
- The approximate confidence limits are truncated to 0% and 100% respectively. 
- ***Note***: The percentiles  $\xi^{25}_{R_{\mathit{S}t}}$ and $\xi^{75}_{R_{\mathit{S}t}}$ is a representation the variation in mortality between farms. The confidence limits on the other hand represents how confident we are that the average risk represents the true average. The with of the confidence interval shrinks towards zero when $n_{\mathit{S}t}$ increases, whereas the percentiles are not systematically affected by $n_{\mathit{S}t}$.


#### Production cycle cumulative mortality
For the analysis the input variables are the same as for monthly mortalities, i.e. 
- ***site\_nr*** (Character). ID for farm/ site.
- ***species*** (Character). The two species of interest/ that are used is "Laks" and "Regnbueørret".
- ***date*** (Date). The resolution is monthly.
- ***at_risk*** (Double/numeric). The number of fish "at risk" in a farm. Let $N_{it}$ be the number of fish present at the start of the month for farm $i$ in month $t$. Furthermore, let $\overline{N_{it}}=\frac{N_{it}+N_{i(t+1)}}{2}$ denote the number of fish "***at_risk***". This is the average number of the number registered at the start of the month and the end of the month (= start point next month). *NB!* It is not necessarily so that $N_{i(t+1)} = N_{it}-M_{it}$, where $M_{it}$ is the number of dead fish (see below), as fish might vanish from farms for other reasons (for instance escaped) than the ones registered as ***dead***.
- ***dead*** The number of registered dead fish per site and month. Let $M_{it}$ denote the number of dead fish in farm $i$, month $t$.
- ***area*** (Character): Management area.
- ***county*** (Character): County.

In addition the variable: 
- ***months_at_sea*** (Integer) The number of months that the production cycle has been in the sea. The first month is given "1", etc. The month of slaughtering is coded with "0".


The first step is to identify valid production cycles. The following criteria is used:
1. The production cycle has to be registered as slaughtered (the last month has registration "0" for variable $months\_at\_sea$).
2. The production cycle has to have valid registrations for $at\_risk$ and $dead$ for all months in the cycle (no missing data allowed).
3. The production cycle has to 


Let $\mathit{S}y$ denote a subset production cycles fulfilling point 1-3 above wich are slaughtered within a given year ($y$) and geographical aggregation level (MA, county or the whole country). Then, for each subset defined in the input the following numbers are calculated:

- $n_{\mathit{S}y}$: The number of production cycles ending in year $y$. 
- The cumulative total mortality risk for each production cycle, $R^{tot}_{i,t,t+n}$, by equation (3).  
- $\xi^{25}_{R^{tot}_{\mathit{S}y}}$, $\xi^{50}_{R^{tot}_{\mathit{S}y}}$ and $\xi^{75}_{R^{tot}_{\mathit{S}y}}$, i.e. 25%, 50% (median) and 75% percentiles for cumulative total mortality risk within the subset ($\mathit{S}y$) in question. 
- ***Note***: Only 25%, 50% (median) and 75% percentiles are presented in the Laksetap app. These percentiles are based on production cycles ending in the same year, but which might have different months at sea.

# Yearly cumulative mortality
### The current solution
Again let $\mathit{S}$ denote the subset of farms in question. The current solution for yearly cumulative mortality is as follows: 

- ***Step 1***: Calculate monthly mortality rates $\Delta M_{it}$ for all farms in and months with data according to Eq. (1) in $\mathit{S}$.
- ***Step 2**** Let $n_{\mathit{S}t}$ be the number of farms with valid data in $\mathit{S}$ in month $t$. <!-- and $\xi^{25}_{M_{\mathit{S}t}}$, $\xi^{50}_{M_{\mathit{S}t}}$ and $\xi^{75}_{M_{\mathit{S}t}}$ be the associated 25\%, 50\% (median) and 75\% percentiles for the *mortality rates*. ***NB! note:*** In the current solution percentiles used in the process for cumulative yearly mortality are based on mortality rates, not mortality risks as for the monthly calculations.-->The mean mortality rate in the month is calculated as  $\overline{\Delta M_{\mathit{S}t}} = \frac{1}{n_{\mathit{S}t}}\sum_{i \in \mathit{S}}\Delta M_{it}$ 
- ***Step 3*** Approximate lower and upper 95\% confidence limits for monthly mortality rates are calculated as $[U_{\mathit{s}t}\hspace{2mm}L_{\mathit{s}t}] = \overline{\Delta M_{\mathit{S}t}}\pm1.96\sqrt{\frac{\sum_{i \in \mathit{S}}\left(\Delta M_{it}-\overline{\Delta M_{\mathit{S}t}}\right)^2}{n_{\mathit{S}}t(n_{\mathit{S}t)}-1)}}$.
- ***Step 4*** For every year and month the mean, confidence limits for the mean <!-- , and percentiles for the--> cumulative ***mortality risk*** is calculated by using the mean and confidence limits <!-- and percentiles--> defined in ***Step 2*** and ***Step 3*** above in Eq. (3). For what it is worth, Lars Erik do not think that these calculations are meaningful for <!-- either--> the confidence limits<!-- or the percentiles-->. I assume the mean calculations are at least close to valid. 


#### Proposed solution
For the release medio May 2026 LEG suggest to just use the mean yearly cumulative mortality risks and skip the confidence intervals. 

For the future we might want to do something like: 

In order to get meaningful confidence limits for the mean cumulative mortality risk over the year and percentiles that represent the between farm variation the proposed solution is to first calculate yearly cumulative mortality risks per farm, and then do the averages, approximate confidence limits and percentiles monthly based on these results. There is one major challenge with this approach, which is missing data. In order to calculate the cumulative risk for month $T\in{1,\ldots,12}$ complete data for months $1,\ldots,T$ is needed. 


Two possible solutions are proposed. One approach, is in line with calculations for production cycle, to only utilize the farms with complete data (i.e. from the first month/ January in yearly calculations) until that month. This solution is stringent, however all the information from that lack data from one of the previous months within the year would be unused. 

Another solution might be to impute data. All farms within the subset $\mathit{S}$ with at least $n_{min}$ (we propose $n_min = 8$) observations of mortality rate is included in the calculations. For the eventual months with missing data, the mortality rate of the farm with missing data is set to the average mortality rate for the farms with observation for the subset $\mathit{S}$ in question in this month. 

Then, for both solutions above, cumulative mortality risks ($R^{tot}_{i,t}$ is the cumulative mortality risk for farm $i$, month $t$) are calculated independently for all farms included for the analysis be Equation (3). Then 

- $n_{\mathit{S}t}$: The number of active farms, i.e. the number of farms with valid mortality rate for the month $t$ in question. Note that if the method where only farms with complete data till month $t$ is used then $n_{\mathit{S}1}\geq n_{\mathit{S}2}\geq\ldots n_{\mathit{S}t_{max}]}$. 
- $\xi^{25}_{R^{tot}_{\mathit{S}t}}$, $\xi^{50}_{R^{tot}_{\mathit{S}t}}$ and $\xi^{75}_{R^{tot}_{\mathit{S}t}}$, i.e. 25%, 50% (median) and 75% percentiles for mortality risk within the subset ($\mathit{S}$) in question. 
- The mean cumulative mortality risk ($\overline{R^{tot}_{\mathit{S}t}}$) for subset $\mathit{S}$, month $t$ calculated as $\overline{R^{tot}_{\mathit{S}t}} = \frac{1}{n_{\mathit{S}t}}\sum_{i\in \mathit{S}}R^{tot}_{it}$.
- Approximate lower and upper limits for a 95% Confidence interval for the ***TRUE*** risk in subset $\mathit{S}$ in month $t$ given as $\overline{R^{tot}_{\mathit{S}t}} \pm 1.96\underset{\text{standard error}}{\underbrace{\sqrt{\frac{\sum_{i\in \mathit{S}}\left(R^{tot}_{it}-\overline{R^{tot}_{\mathit{S}t}}\right)^2}{n_{\mathit{S}t}(n_{\mathit{S}t}-1)}}}}$. 
- The approximate confidence limits are truncated to 0% and 100% respectively. 

